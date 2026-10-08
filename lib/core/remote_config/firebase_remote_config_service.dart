import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/remote_config/remote_config_keys.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'firebase_remote_config_service.g.dart';

/// Service for feature flags and remote configuration using Firebase Remote Config.
///
/// ## Setup Required:
///
/// 1. Complete Firebase setup (see CrashlyticsService docs)
/// 2. Configure defaults in Firebase Console > Remote Config
///
/// ## Usage:
///
/// ```dart
/// final remoteConfig = ref.read(firebaseRemoteConfigServiceProvider);
///
/// // Get feature flags
/// final isFeatureEnabled = remoteConfig.getBool(RemoteConfigKeys.newFeatureEnabled);
/// final apiVersion = remoteConfig.getString(RemoteConfigKeys.apiVersion);
/// final maxItems = remoteConfig.getInt(RemoteConfigKeys.maxCartItems);
/// final discount = remoteConfig.getDouble(RemoteConfigKeys.discountPercentage);
///
/// // Force update check
/// if (remoteConfig.getBool(RemoteConfigKeys.forceUpdateEnabled)) {
///   final minVersion = remoteConfig.getString(RemoteConfigKeys.minAppVersion);
///   // Show force update dialog
/// }
///
/// // Fetch and activate new config
/// await remoteConfig.fetchAndActivate();
/// ```
///
/// ## Best Practices:
/// - Always provide default values for all keys
/// - Use Remote Config for feature flags, not sensitive data
/// - Implement graceful fallbacks when fetch fails
/// - Don't fetch too frequently (has quotas)
@Riverpod(keepAlive: true)
FirebaseRemoteConfigService firebaseRemoteConfigService(Ref ref) {
  return FirebaseRemoteConfigService(ref);
}

/// Firebase Remote Config wrapper service.
class FirebaseRemoteConfigService {
  /// Creates a [FirebaseRemoteConfigService] instance.
  new(this._ref);

  final Ref _ref;
  FirebaseRemoteConfig? _remoteConfig;
  bool _isInitialized = false;

  AppLogger get _logger => _ref.read(loggerProvider);

  /// Whether Remote Config is initialized and enabled.
  bool get isEnabled => _isInitialized && _remoteConfig != null;

  /// Initialize Firebase Remote Config.
  ///
  /// Call this after Firebase.initializeApp().
  /// [minimumFetchInterval] controls how often new values can be fetched.
  /// Default is 1 hour in production, 0 in debug.
  Future<void> initialize({
    Duration? minimumFetchInterval,
    Duration? fetchTimeout,
  }) async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configure settings
      final minFetch =
          minimumFetchInterval ??
          (kDebugMode ? Duration.zero : const Duration(hours: 1));
      final timeout = fetchTimeout ?? const Duration(seconds: 10);

      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: timeout,
          minimumFetchInterval: minFetch,
        ),
      );

      // Set default values
      await _remoteConfig!.setDefaults(_defaultValues);

      // Fetch and activate initial values
      try {
        await _remoteConfig!.fetchAndActivate();
      } catch (e) {
        _logger.w('Failed to fetch initial remote config, using defaults');
      }

      _isInitialized = true;
      _logger.i('Firebase Remote Config initialized');
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize Firebase Remote Config',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Default values for Remote Config keys.
  /// These are used when the app cannot fetch from Firebase.
  Map<String, dynamic> get _defaultValues => {
    // Feature Flags
    RemoteConfigKeys.maintenanceMode: false,
    RemoteConfigKeys.newFeatureEnabled: false,
    RemoteConfigKeys.betaFeaturesEnabled: false,

    // Force Update
    RemoteConfigKeys.forceUpdateEnabled: false,
    RemoteConfigKeys.minAppVersion: '1.0.0',
    RemoteConfigKeys.updateMessage: 'Please update to the latest version.',
    RemoteConfigKeys.updateUrl: '',

    // API Configuration
    RemoteConfigKeys.apiVersion: 'v1',
    RemoteConfigKeys.apiBaseUrl: EnvConfig.baseUrl,

    // Rate Limiting
    RemoteConfigKeys.maxApiRetries: 3,
    RemoteConfigKeys.apiTimeoutSeconds: 30,

    // UI Configuration
    RemoteConfigKeys.showAds: false,
    RemoteConfigKeys.showPromotion: false,
    RemoteConfigKeys.promotionMessage: '',
    RemoteConfigKeys.promotionUrl: '',

    // Feature Limits
    RemoteConfigKeys.maxUploadSizeMb: 10,
    RemoteConfigKeys.maxItemsPerPage: 20,

    // A/B Testing
    RemoteConfigKeys.experimentGroup: 'control',

    // Support
    RemoteConfigKeys.supportEmail: 'support@example.com',
    RemoteConfigKeys.supportUrl: '',
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VALUE GETTERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get a boolean value.
  bool getBool(String key) {
    if (!isEnabled) {
      return _defaultValues[key] as bool? ?? false;
    }
    return _remoteConfig!.getBool(key);
  }

  /// Get a string value.
  String getString(String key) {
    if (!isEnabled) {
      return _defaultValues[key] as String? ?? '';
    }
    return _remoteConfig!.getString(key);
  }

  /// Get an integer value.
  int getInt(String key) {
    if (!isEnabled) {
      return _defaultValues[key] as int? ?? 0;
    }
    return _remoteConfig!.getInt(key);
  }

  /// Get a double value.
  double getDouble(String key) {
    if (!isEnabled) {
      return _defaultValues[key] as double? ?? 0.0;
    }
    return _remoteConfig!.getDouble(key);
  }

  /// Get a value as a RemoteConfigValue.
  RemoteConfigValue? getValue(String key) {
    if (!isEnabled) return null;
    return _remoteConfig!.getValue(key);
  }

  /// Get all values.
  Map<String, RemoteConfigValue> getAll() {
    if (!isEnabled) return {};
    return _remoteConfig!.getAll();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FETCH & ACTIVATE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Fetch new values from Firebase.
  ///
  /// Respects [minimumFetchInterval] to avoid excessive fetches.
  Future<void> fetch() async {
    if (!isEnabled) return;

    try {
      await _remoteConfig!.fetch();
    } catch (e) {
      _logger.e('Failed to fetch remote config', error: e);
    }
  }

  /// Activate fetched values.
  ///
  /// Returns true if values were activated.
  Future<bool> activate() async {
    if (!isEnabled) return false;

    try {
      return await _remoteConfig!.activate();
    } catch (e) {
      _logger.e('Failed to activate remote config', error: e);
      return false;
    }
  }

  /// Fetch and activate in one call.
  ///
  /// Returns true if new values were activated.
  Future<bool> fetchAndActivate() async {
    if (!isEnabled) return false;

    try {
      return await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      _logger.e('Failed to fetch and activate remote config', error: e);
      return false;
    }
  }

  /// Get the time of last successful fetch.
  DateTime? get lastFetchTime {
    if (!isEnabled) return null;
    return _remoteConfig!.lastFetchTime;
  }

  /// Get the status of the last fetch attempt.
  RemoteConfigFetchStatus? get lastFetchStatus {
    if (!isEnabled) return null;
    return _remoteConfig!.lastFetchStatus;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // REAL-TIME UPDATES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Listen for real-time config updates.
  ///
  /// This allows the app to react to config changes without restarting.
  Stream<RemoteConfigUpdate>? get onConfigUpdated {
    if (!isEnabled) return null;
    return _remoteConfig!.onConfigUpdated;
  }

  /// Set up a listener for real-time updates.
  ///
  /// Example:
  /// ```dart
  /// remoteConfig.listenForUpdates((updatedKeys) {
  ///   if (updatedKeys.contains(RemoteConfigKeys.maintenanceMode)) {
  ///     // Handle maintenance mode change
  ///   }
  /// });
  /// ```
  void listenForUpdates(void Function(Set<String> updatedKeys) onUpdate) {
    if (!isEnabled) return;

    _remoteConfig!.onConfigUpdated.listen((event) async {
      await _remoteConfig!.activate();
      onUpdate(event.updatedKeys);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CONVENIENCE METHODS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check if the app is in maintenance mode.
  bool get isMaintenanceMode => getBool(RemoteConfigKeys.maintenanceMode);

  /// Check if a force update is required.
  bool get isForceUpdateRequired =>
      getBool(RemoteConfigKeys.forceUpdateEnabled);

  /// Get the minimum required app version.
  String get minAppVersion => getString(RemoteConfigKeys.minAppVersion);

  /// Check if a feature is enabled.
  bool isFeatureEnabled(String featureKey) => getBool(featureKey);
}
