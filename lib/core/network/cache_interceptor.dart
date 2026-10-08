import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_service.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

/// Interceptor for offline-first caching of API responses.
///
/// ## Features:
/// - Caches GET responses automatically
/// - Returns cached data when offline
/// - Supports ETag-based conditional requests (304 Not Modified)
/// - Configurable cache duration per request
/// - Stale-while-revalidate pattern support
///
/// ## Usage:
///
/// Add to Dio interceptors:
/// ```dart
/// dio.interceptors.add(
///   CacheInterceptor(
///     cacheService: ref.read(cacheServiceProvider),
///     connectivityService: ref.read(connectivityServiceProvider),
///   ),
/// );
/// ```
///
/// Control caching per request using `extra`:
/// ```dart
/// // Disable caching for this request
/// dio.get('/users', options: Options(extra: {'noCache': true}));
///
/// // Custom cache duration
/// dio.get('/users', options: Options(extra: {'cacheDuration': Duration(hours: 1)}));
///
/// // Force refresh (bypass cache, but still store result)
/// dio.get('/users', options: Options(extra: {'forceRefresh': true}));
/// ```
class CacheInterceptor extends Interceptor {
  /// Creates a [CacheInterceptor] instance.
  new({
    required this.cacheService,
    required this.connectivityService,
    this.logger,
    this.defaultDuration = AppConstants.cacheExpiry,
    this.cacheBoxName = apiCacheBoxName,
  });

  /// Cache service for storing/retrieving cached responses.
  final CacheService cacheService;

  /// Connectivity service to check online/offline status.
  final ConnectivityService connectivityService;

  /// Optional logger for debugging.
  final AppLogger? logger;

  /// Default cache duration if not specified per request.
  final Duration defaultDuration;

  /// Name of the cache box/category to use.
  final String cacheBoxName;

  /// Extra key to disable caching for a request.
  static const String noCacheKey = 'noCache';

  /// Extra key for custom cache duration.
  static const String cacheDurationKey = 'cacheDuration';

  /// Extra key to force refresh (bypass cache read).
  static const String forceRefreshKey = 'forceRefresh';

  /// Extra key for stale-while-revalidate (return stale, then update).
  static const String staleWhileRevalidateKey = 'staleWhileRevalidate';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // Check if caching is disabled for this request
    if (options.extra[noCacheKey] == true) {
      return handler.next(options);
    }

    // Check if force refresh is requested
    final forceRefresh = options.extra[forceRefreshKey] == true;

    // Generate cache key from request
    final cacheKey = _generateCacheKey(options);

    // If not forcing refresh, try to get cached response
    if (!forceRefresh) {
      final cachedEntry = await cacheService.get(
        cacheKey,
        boxName: cacheBoxName,
      );

      // If offline, return cached data (even if expired)
      final isConnected = await connectivityService.isConnected();
      if (!isConnected) {
        if (cachedEntry != null) {
          logger?.d('Offline: returning cached response for ${options.path}');
          return handler.resolve(_buildCachedResponse(options, cachedEntry));
        } else {
          // No cache and offline - let the request fail
          return handler.next(options);
        }
      }

      // If cached data is valid, return it
      if (cachedEntry != null && cachedEntry.isValid) {
        logger?.d('Cache hit: ${options.path}');
        return handler.resolve(_buildCachedResponse(options, cachedEntry));
      }

      // Add If-None-Match header for conditional request if we have an ETag
      if (cachedEntry?.etag != null) {
        options.headers['If-None-Match'] = cachedEntry!.etag;
      }
    }

    // Store cache entry for potential 304 response handling
    options.extra['_cachedEntry'] = await cacheService.get(
      cacheKey,
      boxName: cacheBoxName,
    );
    options.extra['_cacheKey'] = cacheKey;

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (response.requestOptions.method != 'GET') {
      return handler.next(response);
    }

    // Check if caching is disabled
    if (response.requestOptions.extra[noCacheKey] == true) {
      return handler.next(response);
    }

    final cacheKey = response.requestOptions.extra['_cacheKey'] as String?;
    if (cacheKey == null) {
      return handler.next(response);
    }

    // Handle 304 Not Modified
    if (response.statusCode == 304) {
      final cachedEntry =
          response.requestOptions.extra['_cachedEntry'] as CacheEntry?;
      if (cachedEntry != null) {
        logger?.d('304 Not Modified: using cached response');
        // Extend cache expiration
        final duration = _getCacheDuration(response.requestOptions);
        await cacheService.put(
          cacheKey,
          cachedEntry.data,
          duration: duration,
          etag: cachedEntry.etag,
          boxName: cacheBoxName,
        );
        return handler.resolve(
          _buildCachedResponse(response.requestOptions, cachedEntry),
        );
      }
    }

    // Cache successful responses
    if (response.statusCode == 200) {
      try {
        final duration = _getCacheDuration(response.requestOptions);
        final etag = response.headers.value('etag');
        final data = jsonEncode(response.data);

        await cacheService.put(
          cacheKey,
          data,
          duration: duration,
          etag: etag,
          boxName: cacheBoxName,
        );
        logger?.d('Cached response for: ${response.requestOptions.path}');
      } catch (e) {
        logger?.w('Failed to cache response: $e');
      }
    }

    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only try cache fallback for GET requests
    if (err.requestOptions.method != 'GET') {
      return handler.next(err);
    }

    // Check if caching is disabled
    if (err.requestOptions.extra[noCacheKey] == true) {
      return handler.next(err);
    }

    // On network error, try to return cached data
    if (_isNetworkError(err)) {
      final cacheKey = _generateCacheKey(err.requestOptions);
      final cachedEntry = await cacheService.get(
        cacheKey,
        boxName: cacheBoxName,
      );

      if (cachedEntry != null) {
        logger?.d('Network error: falling back to cached response');
        return handler.resolve(
          _buildCachedResponse(
            err.requestOptions,
            cachedEntry,
            isStale: cachedEntry.isExpired,
          ),
        );
      }
    }

    return handler.next(err);
  }

  /// Generate a unique cache key from the request options.
  String _generateCacheKey(RequestOptions options) {
    final buffer = StringBuffer()
      ..write(options.method)
      ..write(':')
      ..write(options.baseUrl)
      ..write(options.path);

    // Include query parameters in key
    if (options.queryParameters.isNotEmpty) {
      final sortedParams = Map.fromEntries(
        options.queryParameters.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      );
      buffer.write('?${Uri(queryParameters: sortedParams).query}');
    }

    return buffer.toString();
  }

  /// Get cache duration from request options or use default.
  Duration _getCacheDuration(RequestOptions options) {
    final customDuration = options.extra[cacheDurationKey];
    if (customDuration is Duration) {
      return customDuration;
    }
    return defaultDuration;
  }

  /// Build a response from cached data.
  Response<dynamic> _buildCachedResponse(
    RequestOptions options,
    CacheEntry entry, {
    bool isStale = false,
  }) {
    return Response<dynamic>(
      requestOptions: options,
      data: jsonDecode(entry.data),
      statusCode: 200,
      statusMessage: 'OK (from cache${isStale ? ' - stale' : ''})',
      headers: Headers.fromMap({
        'x-cache': [if (isStale) 'STALE' else 'HIT'],
        'x-cache-date': [entry.timestamp.toIso8601String()],
        if (entry.etag != null) 'etag': [entry.etag!],
      }),
    );
  }

  /// Check if the error is a network-related error.
  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown;
  }
}
