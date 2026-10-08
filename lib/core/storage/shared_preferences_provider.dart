import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for [SharedPreferences].
///
/// Must be overridden in [ProviderScope.overrides] during app startup with
/// the instance obtained before running the app:
/// ```dart
/// ProviderScope(
///   overrides: [
///     sharedPreferencesProvider.overrideWithValue(sharedPreferences),
///   ],
///   child: const AppBootstrap(),
/// )
/// ```
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope during app startup.',
  );
});
