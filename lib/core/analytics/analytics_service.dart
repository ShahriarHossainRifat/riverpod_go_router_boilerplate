import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/analytics/analytics_events.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'analytics_service.g.dart';

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
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(ref);
}

/// Provides the FirebaseAnalyticsObserver for GoRouter.
@Riverpod(keepAlive: true)
FirebaseAnalyticsObserver? analyticsObserver(Ref ref) {
  final analytics = ref.watch(analyticsServiceProvider);
  return analytics.observer;
}

/// Firebase Analytics wrapper service.
class AnalyticsService {
  /// Creates an [AnalyticsService] instance.
  new(this._ref);

  final Ref _ref;
  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;
  bool _isInitialized = false;

  AppLogger get _logger => _ref.read(loggerProvider);

  /// Whether Analytics is enabled.
  bool get isEnabled =>
      !kDebugMode && EnvConfig.isProd && _isInitialized && _analytics != null;

  /// Get the analytics observer for navigation tracking.
  FirebaseAnalyticsObserver? get observer => _observer;

  /// Initialize Firebase Analytics.
  ///
  /// Call this after Firebase.initializeApp().
  Future<void> initialize({bool enableInDebug = false}) async {
    try {
      _analytics = FirebaseAnalytics.instance;

      final shouldEnable = enableInDebug || (!kDebugMode && EnvConfig.isProd);
      await _analytics!.setAnalyticsCollectionEnabled(shouldEnable);

      if (shouldEnable) {
        _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      }

      _isInitialized = true;
      _logger.i('Firebase Analytics initialized (enabled: $shouldEnable)');
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize Firebase Analytics',
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PREDEFINED EVENTS (Firebase recommended events)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Log user login event.
  Future<void> logLogin({String? method}) async {
    if (method != null) {
      await _logEvent(AnalyticsEvents.login, parameters: {'method': method});
    } else {
      await _logEvent(AnalyticsEvents.login);
    }
  }

  /// Log user signup event.
  Future<void> logSignUp({String? method}) async {
    if (method != null) {
      await _logEvent(AnalyticsEvents.signUp, parameters: {'method': method});
    } else {
      await _logEvent(AnalyticsEvents.signUp);
    }
  }

  /// Log screen view event.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isEnabled) return;

    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      _logger.e('Failed to log screen view', error: e);
    }
  }

  /// Log search event.
  Future<void> logSearch({required String searchTerm}) async {
    await _logEvent(
      AnalyticsEvents.search,
      parameters: {'search_term': searchTerm},
    );
  }

  /// Log share event.
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await _logEvent(
      AnalyticsEvents.share,
      parameters: {
        'content_type': contentType,
        'item_id': itemId,
        'method': ?method,
      },
    );
  }

  /// Log purchase event.
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    List<AnalyticsEventItem>? items,
  }) async {
    if (!isEnabled) return;

    try {
      await _analytics!.logPurchase(
        transactionId: transactionId,
        value: value,
        currency: currency,
        items: items,
      );
    } catch (e) {
      _logger.e('Failed to log purchase', error: e);
    }
  }

  /// Log tutorial begin event.
  Future<void> logTutorialBegin() async {
    await _logEvent(AnalyticsEvents.tutorialBegin);
  }

  /// Log tutorial complete event.
  Future<void> logTutorialComplete() async {
    await _logEvent(AnalyticsEvents.tutorialComplete);
  }

  /// Log button click event.
  Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
  }) async {
    await _logEvent(
      AnalyticsEvents.buttonClick,
      parameters: {'button_name': buttonName, 'screen_name': ?screenName},
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CUSTOM EVENTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Log a custom event.
  ///
  /// Use constants from [AnalyticsEvents] for consistency.
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _logEvent(name, parameters: parameters);
  }

  Future<void> _logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!isEnabled) {
      _logger.d('Analytics disabled, skipping event: $name');
      return;
    }

    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (e) {
      _logger.e('Failed to log event: $name', error: e);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // USER PROPERTIES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Set the user ID for analytics.
  ///
  /// Use a hashed/anonymized identifier for privacy.
  Future<void> setUserId(String? userId) async {
    if (!isEnabled) return;

    try {
      await _analytics!.setUserId(id: userId);
    } catch (e) {
      _logger.e('Failed to set analytics user ID', error: e);
    }
  }

  /// Set a user property for segmentation.
  ///
  /// User properties help segment your users for analysis.
  /// Examples: subscription_tier, preferred_language, account_type
  Future<void> setUserProperty(String name, String? value) async {
    if (!isEnabled) return;

    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      _logger.e('Failed to set user property: $name', error: e);
    }
  }

  /// Reset analytics data (e.g., on logout).
  Future<void> resetAnalyticsData() async {
    if (!isEnabled) return;

    try {
      await _analytics!.resetAnalyticsData();
    } catch (e) {
      _logger.e('Failed to reset analytics data', error: e);
    }
  }

  /// Set whether analytics collection is enabled.
  Future<void> setEnabled(bool enabled) async {
    if (_analytics == null) return;

    try {
      await _analytics!.setAnalyticsCollectionEnabled(enabled);
      _logger.i('Analytics collection set to: $enabled');
    } catch (e) {
      _logger.e('Failed to set analytics collection', error: e);
    }
  }

  /// Set default event parameters (appear on all events).
  Future<void> setDefaultParameters(Map<String, Object?>? parameters) async {
    if (!isEnabled) return;

    try {
      await _analytics!.setDefaultEventParameters(parameters);
    } catch (e) {
      _logger.e('Failed to set default parameters', error: e);
    }
  }
}
