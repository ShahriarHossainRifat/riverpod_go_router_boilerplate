import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/storage_keys.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

/// Callback type for token refresh logic.
/// Returns true if refresh was successful, false otherwise.
/// Implement this to call your backend's refresh token endpoint.
typedef TokenRefreshCallback = Future<bool> Function(
  String? refreshToken,
  Future<void> Function(String accessToken, String? refreshToken) saveTokens,
);

/// Callback type for handling authentication failures.
/// Called when token refresh fails and the user needs to re-authenticate.
typedef OnAuthFailureCallback = void Function();

/// Interceptor for adding authentication headers and handling token refresh.
///
/// Uses a [Completer] to ensure concurrent 401 responses wait for the same
/// refresh operation, preventing multiple simultaneous refresh attempts.
///
/// The refresh logic is injectable via [onRefreshToken] callback, allowing
/// you to customize the refresh behavior for your specific backend.
///
/// When refresh fails, [onAuthFailure] is called to trigger logout/redirect.
///
/// Example:
/// ```dart
/// AuthInterceptor(
///   ref,
///   parentDio: dio,
///   onRefreshToken: (refreshToken, saveTokens) async {
///     final response = await Dio().post('/auth/refresh', data: {'token': refreshToken});
///     await saveTokens(response.data['access_token'], response.data['refresh_token']);
///     return true;
///   },
///   onAuthFailure: () {
///     // Trigger logout, this will update session state and redirect to login
///     ref.read(authProvider.notifier).logout();
///   },
/// )
/// ```
class AuthInterceptor extends QueuedInterceptor {
  /// Creates an [AuthInterceptor] instance.
  new(
    this._ref, {
    required this.parentDio,
    this.onRefreshToken,
    this.onAuthFailure,
  });

  final Ref _ref;

  /// The parent Dio instance used for retrying requests.
  final Dio parentDio;

  /// Optional callback for custom token refresh logic.
  final TokenRefreshCallback? onRefreshToken;

  /// Optional callback triggered when authentication fails permanently.
  /// Use this to logout the user and redirect to login.
  final OnAuthFailureCallback? onAuthFailure;

  /// Completer for coordinating concurrent refresh requests.
  /// Multiple 401 responses will wait on the same completer.
  Completer<bool>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Check if a refresh is already in progress
    if (_refreshCompleter != null) {
      // Wait for the ongoing refresh to complete
      final refreshed = await _refreshCompleter!.future;
      if (refreshed) {
        // Retry the request with new token
        try {
          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
      return handler.next(err);
    }

    // Start a new refresh operation
    _refreshCompleter = Completer<bool>();

    try {
      final refreshed = await _refreshToken();
      _refreshCompleter!.complete(refreshed);
      _refreshCompleter = null;

      if (refreshed) {
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      } else {
        await _handleAuthFailure();
      }
    } catch (e) {
      _refreshCompleter?.complete(false);
      _refreshCompleter = null;
      await _handleAuthFailure();
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: StorageKeys.refreshToken);

    if (refreshToken == null || onRefreshToken == null) {
      return false;
    }

    try {
      return await onRefreshToken!(refreshToken, (
        accessToken,
        newRefreshToken,
      ) async {
        await storage.write(key: StorageKeys.accessToken, value: accessToken);
        if (newRefreshToken != null) {
          await storage.write(
            key: StorageKeys.refreshToken,
            value: newRefreshToken,
          );
        }
      });
    } catch (e) {
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);
    options.headers['Authorization'] = 'Bearer $token';
    return parentDio.fetch(options);
  }

  Future<void> _handleAuthFailure() async {
    await _clearTokens();

    // Notify about auth failure (triggers logout and redirect)
    if (onAuthFailure != null) {
      onAuthFailure!();
    }
    // Note: We do NOT invalidate authProvider here to avoid circular dependency errors.
    // The auth provider will detect missing tokens on next build/read.
  }

  Future<void> _clearTokens() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.delete(key: StorageKeys.accessToken);
    await storage.delete(key: StorageKeys.refreshToken);
  }
}

/// Interceptor for retrying failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  /// Creates a [RetryInterceptor] instance.
  new(
    this._dio, {
    this.maxRetries = AppConstants.maxRetryAttempts,
    this.retryDelays,
  });

  final Dio _dio;

  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Optional list of delays between retries.
  final List<Duration>? retryDelays;

  static const _retryKey = 'retry_count';

  List<Duration> get _delays => retryDelays ?? AppConstants.retryDelays;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra[_retryKey] as int? ?? 0;
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    final delay = _delays[retryCount.clamp(0, _delays.length - 1)];
    await Future<void>.delayed(delay);

    try {
      err.requestOptions.extra[_retryKey] = retryCount + 1;
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Interceptor for logging requests and responses in debug mode.
class LoggingInterceptor extends Interceptor {
  /// Creates a [LoggingInterceptor] instance.
  new(this._ref);
  final Ref _ref;

  AppLogger get _logger => _ref.read(loggerProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.d('→ ${options.method} ${options.uri}');
      if (options.data != null) {
        _logger.d('   Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      _logger.d('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '✖ ${err.response?.statusCode ?? 'NETWORK'} ${err.requestOptions.uri}',
        error: err.message,
      );
    }
    handler.next(err);
  }
}
