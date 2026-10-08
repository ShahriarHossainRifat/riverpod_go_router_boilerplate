import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Remote configuration flags that can affect app behavior.
///
/// This is a stub implementation - replace with Firebase Remote Config,
/// LaunchDarkly, or your preferred remote config solution.
class RemoteConfig {
  /// Creates a [RemoteConfig] instance.
  const new({
    this.isMaintenanceMode = false,
    this.maintenanceMessage,
    this.minimumVersion,
    this.forceUpdate = false,
    this.featureFlags = const {},
  });

  /// Whether the app is in maintenance mode.
  final bool isMaintenanceMode;

  /// Optional maintenance message to display to users.
  final String? maintenanceMessage;

  /// Minimum required app version.
  final String? minimumVersion;

  /// Whether a force update is required.
  final bool forceUpdate;

  /// Feature flags for enabling/disabling features.
  final Map<String, bool> featureFlags;

  /// Get the value of a feature flag by key.
  bool getFlag(String key, {bool defaultValue = false}) {
    return featureFlags[key] ?? defaultValue;
  }

  /// Returns a copy of this config with the given fields replaced.
  RemoteConfig copyWith({
    bool? isMaintenanceMode,
    String? maintenanceMessage,
    String? minimumVersion,
    bool? forceUpdate,
    Map<String, bool>? featureFlags,
  }) {
    return RemoteConfig(
      isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      forceUpdate: forceUpdate ?? this.forceUpdate,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }
}

/// Service for fetching and managing remote configuration.
///
/// Stub implementation - replace internals with your remote config provider.
class RemoteConfigService {
  /// Creates a [RemoteConfigService] instance.
  new();

  RemoteConfig _currentConfig = const RemoteConfig();
  final _configController = StreamController<RemoteConfig>.broadcast();

  /// Current remote configuration.
  RemoteConfig get currentConfig => _currentConfig;

  /// Stream of remote configuration updates.
  Stream<RemoteConfig> get configStream => _configController.stream;

  /// Fetch the latest configuration from remote.
  ///
  /// In a real implementation, this would call Firebase Remote Config,
  /// a REST API, or your preferred config service.
  Future<RemoteConfig> fetch() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // In real implementation:
    // final response = await FirebaseRemoteConfig.instance.fetchAndActivate();
    // return RemoteConfig(
    //   isMaintenanceMode: FirebaseRemoteConfig.instance.getBool('maintenance_mode'),
    //   ...
    // );

    return _currentConfig;
  }

  /// Initialize the service and fetch initial config.
  Future<void> initialize() async {
    _currentConfig = await fetch();
    _configController.add(_currentConfig);
  }

  /// Manually update config (useful for testing or local overrides).
  void updateConfig(RemoteConfig config) {
    _currentConfig = config;
    _configController.add(_currentConfig);
  }

  /// Enable maintenance mode (useful for testing).
  void enableMaintenance({String? message}) {
    updateConfig(
      _currentConfig.copyWith(
        isMaintenanceMode: true,
        maintenanceMessage: message,
      ),
    );
  }

  /// Disable maintenance mode.
  void disableMaintenance() {
    updateConfig(_currentConfig.copyWith(isMaintenanceMode: false));
  }

  /// Set a feature flag.
  void setFeatureFlag(String key, bool value) {
    final newFlags = Map<String, bool>.from(_currentConfig.featureFlags);
    newFlags[key] = value;
    updateConfig(_currentConfig.copyWith(featureFlags: newFlags));
  }

  /// Dispose the service and close streams.
  void dispose() {
    _configController.close();
  }
}

/// Provider for the RemoteConfigService singleton.
final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  final service = RemoteConfigService();
  ref.onDispose(service.dispose);
  return service;
});

/// Provider for the current remote config.
final remoteConfigProvider = StreamProvider<RemoteConfig>((ref) {
  final service = ref.watch(remoteConfigServiceProvider);
  return service.configStream;
});

/// Provider for checking if app is in maintenance mode.
final isMaintenanceModeProvider = Provider<bool>((ref) {
  final config = ref.watch(remoteConfigProvider);
  return config.value?.isMaintenanceMode ?? false;
});

/// Provider for the maintenance message.
final maintenanceMessageProvider = Provider<String?>((ref) {
  final config = ref.watch(remoteConfigProvider);
  return config.value?.maintenanceMessage;
});
