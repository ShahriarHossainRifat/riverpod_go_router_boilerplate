import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart'
    show PerformanceHttpInterceptor;
import 'package:riverpod_go_router_boilerplate/core/performance/performance.dart'
    show PerformanceHttpInterceptor;
import 'package:riverpod_go_router_boilerplate/core/performance/performance_http_interceptor.dart'
    show PerformanceHttpInterceptor;
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'performance_service.g.dart';

/// Service for performance monitoring using Firebase Performance.
///
/// ## Setup Required:
///
/// 1. Complete Firebase setup (see CrashlyticsService docs)
/// 2. Firebase Performance SDK is automatically enabled
///
/// ## Usage:
///
/// ```dart
/// // Start a custom trace
/// final trace = await ref.read(performanceServiceProvider).startTrace('checkout_flow');
///
/// // Add metrics to the trace
/// trace?.incrementMetric('items_count', 5);
/// trace?.putAttribute('payment_method', 'credit_card');
///
/// // ... perform operations ...
///
/// // Stop the trace
/// await trace?.stop();
///
/// // Or use the helper for async operations:
/// final result = await ref.read(performanceServiceProvider).traceAsync(
///   'api_heavy_operation',
///   () => heavyApiCall(),
///   attributes: {'endpoint': '/api/data'},
/// );
/// ```
///
/// ## Automatic Traces:
/// - HTTP requests (via PerformanceHttpInterceptor)
/// - Screen rendering (via PerformanceRouteObserver)
///
/// ## Best Practices:
/// - Use meaningful trace names (e.g., 'checkout_flow', 'image_upload')
/// - Add relevant attributes for filtering in Firebase Console
/// - Keep trace duration reasonable (< 5 minutes)
/// - Don't create too many concurrent traces (< 500)
@Riverpod(keepAlive: true)
PerformanceService performanceService(Ref ref) {
  return PerformanceService(ref);
}

/// Firebase Performance wrapper service.
class PerformanceService {
  /// Creates a [PerformanceService] instance.
  new(this._ref);

  final Ref _ref;
  FirebasePerformance? _performance;
  bool _isInitialized = false;

  AppLogger get _logger => _ref.read(loggerProvider);

  /// Whether Performance monitoring is enabled.
  bool get isEnabled =>
      !kDebugMode && EnvConfig.isProd && _isInitialized && _performance != null;

  /// Initialize Firebase Performance.
  ///
  /// Call this after Firebase.initializeApp().
  Future<void> initialize({bool enableInDebug = false}) async {
    try {
      _performance = FirebasePerformance.instance;

      final shouldEnable = enableInDebug || (!kDebugMode && EnvConfig.isProd);
      await _performance!.setPerformanceCollectionEnabled(shouldEnable);

      _isInitialized = true;
      _logger.i('Firebase Performance initialized (enabled: $shouldEnable)');
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize Firebase Performance',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Start a custom trace.
  ///
  /// Returns null if performance monitoring is disabled.
  /// Remember to call [Trace.stop] when done.
  Future<Trace?> startTrace(String name) async {
    if (!isEnabled) {
      _logger.d('Performance disabled, skipping trace: $name');
      return null;
    }

    try {
      final trace = _performance!.newTrace(name);
      await trace.start();
      return trace;
    } catch (e) {
      _logger.e('Failed to start trace: $name', error: e);
      return null;
    }
  }

  /// Execute an async operation with automatic tracing.
  ///
  /// Automatically starts and stops a trace around the operation.
  /// Returns the result of the operation.
  Future<T> traceAsync<T>(
    String traceName,
    Future<T> Function() operation, {
    Map<String, String>? attributes,
    Map<String, int>? metrics,
  }) async {
    final trace = await startTrace(traceName);

    // Add attributes if provided
    if (trace != null && attributes != null) {
      for (final entry in attributes.entries) {
        trace.putAttribute(entry.key, entry.value);
      }
    }

    // Add initial metrics if provided
    if (trace != null && metrics != null) {
      for (final entry in metrics.entries) {
        trace.setMetric(entry.key, entry.value);
      }
    }

    try {
      final result = await operation();
      trace?.putAttribute('success', 'true');
      return result;
    } catch (e) {
      trace?.putAttribute('success', 'false');
      trace?.putAttribute('error_type', e.runtimeType.toString());
      rethrow;
    } finally {
      await trace?.stop();
    }
  }

  /// Execute a synchronous operation with automatic tracing.
  T traceSync<T>(
    String traceName,
    T Function() operation, {
    Map<String, String>? attributes,
  }) {
    // For sync operations, we can't await, so we fire and forget the trace
    if (!isEnabled) return operation();

    final trace = _performance?.newTrace(traceName);
    trace?.start();

    if (attributes != null) {
      for (final entry in attributes.entries) {
        trace?.putAttribute(entry.key, entry.value);
      }
    }

    try {
      final result = operation();
      trace?.putAttribute('success', 'true');
      return result;
    } catch (e) {
      trace?.putAttribute('success', 'false');
      rethrow;
    } finally {
      trace?.stop();
    }
  }

  /// Create an HTTP metric for tracking network requests.
  ///
  /// This is typically called by [PerformanceHttpInterceptor] automatically.
  HttpMetric? newHttpMetric(String url, HttpMethod method) {
    if (!isEnabled) return null;

    try {
      return _performance!.newHttpMetric(url, method);
    } catch (e) {
      _logger.e('Failed to create HTTP metric', error: e);
      return null;
    }
  }

  /// Set whether performance collection is enabled.
  Future<void> setEnabled(bool enabled) async {
    if (_performance == null) return;

    try {
      await _performance!.setPerformanceCollectionEnabled(enabled);
      _logger.i('Performance collection set to: $enabled');
    } catch (e) {
      _logger.e('Failed to set performance collection', error: e);
    }
  }
}
