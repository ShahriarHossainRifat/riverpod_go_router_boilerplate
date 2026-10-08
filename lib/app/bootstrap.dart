import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/app.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/fresh_install_handler.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bootstrap the application.
/// Handles initialization, error handling, and app startup.
class AppBootstrap extends StatelessWidget {
  /// Creates the [AppBootstrap] widget.
  const new({super.key});

  /// Initialize the app before running.
  /// Call this before runApp().
  static Future<void> initialize({
    Environment environment = Environment.dev,
    bool? useMocks,
  }) async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize environment configuration
    EnvConfig.initialize(environment: environment, useMocks: useMocks);
    AppLogger.instance.i('Environment initialized: ${environment.name}');

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // Note: Drift database is lazily initialized when first accessed
    // via the cacheDatabaseProvider. No explicit initialization needed.

    // ─────────────────────────────────────────────────────────────────────────────
    // Firebase Services Initialization
    // ─────────────────────────────────────────────────────────────────────────────
    // **Setup Required Before Uncommenting:**
    // 1. Run in your project root: flutterfire configure
    // 2. This generates lib/firebase_options.dart
    // 3. TODO: Uncomment the Crashlytics initialization below:
    //
    // Note: Crashlytics must be initialized first for error handling.
    // TODO: Uncomment the following lines:
    // await CrashlyticsService.initialize(
    //   environment: environment,
    //   enableInDebug: false,
    // );

    // Note: Analytics, Performance, and RemoteConfig services are lazily initialized
    // when first accessed through their Riverpod providers. They don't require
    // explicit initialization here since they handle Firebase setup internally.

    // Set up error handling (falls back to local logging if Crashlytics not initialized)
    _setupErrorHandling();

    AppLogger.instance.i('App bootstrap completed');

    // Add any other initialization here:
    // - Load remote config
    // - etc.
  }

  /// Set up global error handling.
  static void _setupErrorHandling() {
    // Handle Flutter errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AppLogger.instance.e(
        'Flutter error: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );
      if (kReleaseMode) {
        _logToCrashReporting(details.exception, details.stack);
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.instance.e('Async error', error: error, stackTrace: stack);
      if (kReleaseMode) {
        _logToCrashReporting(error, stack);
      }
      return true;
    };
  }

  /// Log error to crash reporting service.
  ///
  /// Uses Firebase Crashlytics in production.
  /// Falls back to console logging if not initialized.
  static Future<void> _logToCrashReporting(
    Object error,
    StackTrace? stack,
  ) async {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: 'Uncaught error',
        fatal: true,
      );
      return;
    } catch (_) {
      // Crashlytics not available, fall through to local logging
    }

    // Fallback: Log locally until Firebase is configured
    AppLogger.instance.w('Error would be sent to crash reporting: $error');
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

/// Run a guarded zone for the app with comprehensive error catching.
///
/// This wraps the app in [runZonedGuarded] to catch any uncaught async errors
/// that might otherwise be silently dropped. Use this in production for
/// better error visibility and crash reporting.
///
/// The [appBuilder] callback receives the initialized services and returns
/// the root widget (typically a [ProviderScope] with overrides).
///
/// Example:
/// ```dart
/// void main() {
///   runGuardedApp(
///     environment: Environment.prod,
///     useMocks: false,  // Use real API instead of mocks
///     appBuilder: (sharedPrefs, connectivity) => ProviderScope(
///       overrides: [
///         sharedPreferencesProvider.overrideWithValue(sharedPrefs),
///         connectivityServiceProvider.overrideWithValue(connectivity),
///       ],
///       child: const AppBootstrap(),
///     ),
///   );
/// }
/// ```
Future<void> runGuardedApp({
  required Widget Function(
    SharedPreferences sharedPreferences,
    ConnectivityService connectivity,
  )
  appBuilder,
  Environment environment = Environment.dev,
  bool? useMocks,
}) async {
  await runZonedGuarded(
    () async {
      // Initialize bootstrap (bindings, error handling, etc.)
      await AppBootstrap.initialize(
        environment: environment,
        useMocks: useMocks,
      );

      // Initialize services that need to be ready before UI
      final sharedPreferences = await SharedPreferences.getInstance();
      final connectivityService = ConnectivityService();
      await connectivityService.initialize();

      // Handle fresh install - clear stale Keychain data on iOS
      // This prevents the issue where auth tokens survive app reinstall
      const secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      await FreshInstallHandler.handleFreshInstall(
        prefs: sharedPreferences,
        secureStorage: secureStorage,
      );

      // Run the app with initialized services
      runApp(appBuilder(sharedPreferences, connectivityService));
    },
    (error, stack) {
      AppLogger.instance.f(
        'Uncaught zone error',
        error: error,
        stackTrace: stack,
      );
      if (kReleaseMode) {
        unawaited(AppBootstrap._logToCrashReporting(error, stack));
      }
    },
  );
}
