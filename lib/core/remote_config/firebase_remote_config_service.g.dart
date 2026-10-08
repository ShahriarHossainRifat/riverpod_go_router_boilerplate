// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_remote_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(firebaseRemoteConfigService)
final firebaseRemoteConfigServiceProvider =
    FirebaseRemoteConfigServiceProvider._();

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

final class FirebaseRemoteConfigServiceProvider
    extends
        $FunctionalProvider<
          FirebaseRemoteConfigService,
          FirebaseRemoteConfigService,
          FirebaseRemoteConfigService
        >
    with $Provider<FirebaseRemoteConfigService> {
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
  FirebaseRemoteConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseRemoteConfigServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseRemoteConfigServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseRemoteConfigService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseRemoteConfigService create(Ref ref) {
    return firebaseRemoteConfigService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseRemoteConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseRemoteConfigService>(value),
    );
  }
}

String _$firebaseRemoteConfigServiceHash() =>
    r'2824e14f26d56ad1a1819057e10770e26d4679b1';
