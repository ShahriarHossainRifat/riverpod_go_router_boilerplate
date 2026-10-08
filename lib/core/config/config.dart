/// Configuration module.
///
/// Provides:
/// - [RemoteConfigService] - Remote configuration management (stub)
/// - [remoteConfigProvider] - Reactive remote config state
/// - [isMaintenanceModeProvider] - Maintenance mode check
///
/// Note: For Firebase Remote Config, use `FirebaseRemoteConfigService`
/// from `lib/core/remote_config/`.
library;

import 'package:riverpod_go_router_boilerplate/core/config/config.dart'
    show RemoteConfigService;
import 'package:riverpod_go_router_boilerplate/core/config/remote_config_service.dart'
    show RemoteConfigService;
import 'package:riverpod_go_router_boilerplate/core/core.dart'
    show RemoteConfigService;

export 'remote_config_service.dart';
