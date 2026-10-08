import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/bootstrap.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Application entry point.
///
/// Uses [runGuardedApp] to wrap the app in a guarded zone for
/// comprehensive error catching in production.
void main() {
  runGuardedApp(
    appBuilder: (sharedPreferences, connectivity) => ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      child: const AppBootstrap(),
    ),
  );
}
