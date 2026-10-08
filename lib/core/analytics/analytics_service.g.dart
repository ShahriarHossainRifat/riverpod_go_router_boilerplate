// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service for user analytics using Firebase Analytics.
///
/// ## Setup Required:
///
/// 1. Complete Firebase setup (see CrashlyticsService docs)
/// 2. Firebase Analytics SDK is automatically enabled
///
/// ## Usage:
///
/// ```dart
/// final analytics = ref.read(analyticsServiceProvider);
///
/// // Log a predefined event
/// await analytics.logLogin(method: 'email');
///
/// // Log a custom event
/// await analytics.logEvent(
///   AnalyticsEvents.itemPurchased,
///   parameters: {
///     'item_id': '123',
///     'item_name': 'Premium Plan',
///     'price': 9.99,
///   },
/// );
///
/// // Set user properties
/// await analytics.setUserProperty('subscription_tier', 'premium');
///
/// // Track screen views (automatic with AnalyticsRouteObserver)
/// await analytics.logScreenView(screenName: 'checkout');
/// ```
///
/// ## Best Practices:
/// - Use predefined events when possible (better insights)
/// - Keep custom event names concise and consistent
/// - Don't log PII (personally identifiable information)
/// - Use user properties for segmentation

@ProviderFor(analyticsService)
final analyticsServiceProvider = AnalyticsServiceProvider._();

/// Service for user analytics using Firebase Analytics.
///
/// ## Setup Required:
///
/// 1. Complete Firebase setup (see CrashlyticsService docs)
/// 2. Firebase Analytics SDK is automatically enabled
///
/// ## Usage:
///
/// ```dart
/// final analytics = ref.read(analyticsServiceProvider);
///
/// // Log a predefined event
/// await analytics.logLogin(method: 'email');
///
/// // Log a custom event
/// await analytics.logEvent(
///   AnalyticsEvents.itemPurchased,
///   parameters: {
///     'item_id': '123',
///     'item_name': 'Premium Plan',
///     'price': 9.99,
///   },
/// );
///
/// // Set user properties
/// await analytics.setUserProperty('subscription_tier', 'premium');
///
/// // Track screen views (automatic with AnalyticsRouteObserver)
/// await analytics.logScreenView(screenName: 'checkout');
/// ```
///
/// ## Best Practices:
/// - Use predefined events when possible (better insights)
/// - Keep custom event names concise and consistent
/// - Don't log PII (personally identifiable information)
/// - Use user properties for segmentation

final class AnalyticsServiceProvider
    extends
        $FunctionalProvider<
          AnalyticsService,
          AnalyticsService,
          AnalyticsService
        >
    with $Provider<AnalyticsService> {
  /// Service for user analytics using Firebase Analytics.
  ///
  /// ## Setup Required:
  ///
  /// 1. Complete Firebase setup (see CrashlyticsService docs)
  /// 2. Firebase Analytics SDK is automatically enabled
  ///
  /// ## Usage:
  ///
  /// ```dart
  /// final analytics = ref.read(analyticsServiceProvider);
  ///
  /// // Log a predefined event
  /// await analytics.logLogin(method: 'email');
  ///
  /// // Log a custom event
  /// await analytics.logEvent(
  ///   AnalyticsEvents.itemPurchased,
  ///   parameters: {
  ///     'item_id': '123',
  ///     'item_name': 'Premium Plan',
  ///     'price': 9.99,
  ///   },
  /// );
  ///
  /// // Set user properties
  /// await analytics.setUserProperty('subscription_tier', 'premium');
  ///
  /// // Track screen views (automatic with AnalyticsRouteObserver)
  /// await analytics.logScreenView(screenName: 'checkout');
  /// ```
  ///
  /// ## Best Practices:
  /// - Use predefined events when possible (better insights)
  /// - Keep custom event names concise and consistent
  /// - Don't log PII (personally identifiable information)
  /// - Use user properties for segmentation
  AnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsServiceHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsServiceHash() => r'20332d0f7e201d5ec00bf6d6b39de54d761c020a';

/// Provides the FirebaseAnalyticsObserver for GoRouter.

@ProviderFor(analyticsObserver)
final analyticsObserverProvider = AnalyticsObserverProvider._();

/// Provides the FirebaseAnalyticsObserver for GoRouter.

final class AnalyticsObserverProvider
    extends
        $FunctionalProvider<
          FirebaseAnalyticsObserver?,
          FirebaseAnalyticsObserver?,
          FirebaseAnalyticsObserver?
        >
    with $Provider<FirebaseAnalyticsObserver?> {
  /// Provides the FirebaseAnalyticsObserver for GoRouter.
  AnalyticsObserverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsObserverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsObserverHash();

  @$internal
  @override
  $ProviderElement<FirebaseAnalyticsObserver?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAnalyticsObserver? create(Ref ref) {
    return analyticsObserver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAnalyticsObserver? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAnalyticsObserver?>(value),
    );
  }
}

String _$analyticsObserverHash() => r'88aef89370f95d5445aa06c54b7e84c54167dc8a';
