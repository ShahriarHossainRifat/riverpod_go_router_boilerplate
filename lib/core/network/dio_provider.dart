import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_service.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/network/cache_interceptor.dart';
import 'package:riverpod_go_router_boilerplate/core/network/interceptors.dart';
import 'package:riverpod_go_router_boilerplate/core/performance/performance_http_interceptor.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'dio_provider.g.dart';

/// Provider for the Dio HTTP client.
///
/// Uses native platform adapters for optimal performance:
/// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
/// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
///
/// Includes interceptors for:
/// - Authentication (token injection, refresh)
/// - Offline caching (automatic cache for GET requests)
/// - Retry (exponential backoff for failed requests)
/// - Logging (request/response logging in debug mode)
///
/// keepAlive: true ensures Dio instance is not disposed when no longer watched.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Use native HTTP adapter for better performance (HTTP/3, Brotli, system proxy)
  // Only in release mode to preserve debugging capabilities in development
  if (kReleaseMode) {
    dio.httpClientAdapter = NativeAdapter();
  }

  // Add interceptors in order of execution
  dio.interceptors.addAll([
    // 1. Performance interceptor - tracks HTTP request metrics (production only)
    PerformanceHttpInterceptor(ref),
    // 2. Auth interceptor - adds tokens, handles 401 refresh
    AuthInterceptor(ref, parentDio: dio),
    // 3. Cache interceptor - offline-first caching for GET requests
    CacheInterceptor(
      cacheService: ref.read(cacheServiceProvider),
      connectivityService: ref.read(connectivityServiceProvider),
      logger: EnvConfig.enableLogging ? ref.read(loggerProvider) : null,
    ),
    // 4. Retry interceptor - exponential backoff for failed requests
    RetryInterceptor(dio),
    // 5. Logging interceptor - request/response logging (debug only)
    if (EnvConfig.enableLogging) LoggingInterceptor(ref),
  ]);

  return dio;
}
