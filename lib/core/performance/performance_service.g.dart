// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(performanceService)
final performanceServiceProvider = PerformanceServiceProvider._();

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

final class PerformanceServiceProvider
    extends
        $FunctionalProvider<
          PerformanceService,
          PerformanceService,
          PerformanceService
        >
    with $Provider<PerformanceService> {
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
  PerformanceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'performanceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$performanceServiceHash();

  @$internal
  @override
  $ProviderElement<PerformanceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PerformanceService create(Ref ref) {
    return performanceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PerformanceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PerformanceService>(value),
    );
  }
}

String _$performanceServiceHash() =>
    r'b2d99af9299da147a33f642275cdb06efcd4976a';
