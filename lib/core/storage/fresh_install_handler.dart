import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/storage_keys.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles fresh install detection and secure storage cleanup.
///
/// On iOS, Keychain data (used by flutter_secure_storage) persists even after
/// the app is uninstalled. This can cause issues where:
/// - User uninstalls app while logged in
/// - User reinstalls app
/// - App shows onboarding (SharedPreferences cleared)
/// - But user appears logged in (Keychain tokens survived)
///
/// This handler detects fresh installs by checking a marker in SharedPreferences.
/// If the marker is missing (fresh install/reinstall), it clears secure storage
/// to ensure a clean state.
///
/// **Usage:**
/// Call [handleFreshInstall] during app initialization, before any auth checks.
///
/// ```dart
/// await FreshInstallHandler.handleFreshInstall(
///   prefs: sharedPreferences,
///   secureStorage: secureStorage,
/// );
/// ```
class FreshInstallHandler {
  new _();

  /// Key used to detect if the app has been run before.
  /// This is stored in SharedPreferences which gets cleared on uninstall.
  static const _hasRunBeforeKey = 'has_run_before';

  /// Handles fresh install detection and cleanup.
  ///
  /// Returns `true` if this was detected as a fresh install and cleanup
  /// was performed.
  static Future<bool> handleFreshInstall({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  }) async {
    final hasRunBefore = prefs.getBool(_hasRunBeforeKey) ?? false;

    if (!hasRunBefore) {
      // This is a fresh install or reinstall
      AppLogger.instance.i(
        'Fresh install detected - clearing secure storage for clean state',
      );

      try {
        // Clear all auth-related secure storage
        await secureStorage.delete(key: StorageKeys.accessToken);
        await secureStorage.delete(key: StorageKeys.refreshToken);
        await secureStorage.delete(key: StorageKeys.tokenExpiry);
        await secureStorage.delete(key: StorageKeys.userId);
        await secureStorage.delete(key: StorageKeys.userEmail);

        // Optionally clear all secure storage for a complete reset
        // await secureStorage.deleteAll();

        if (kDebugMode) {
          debugPrint('✅ Fresh install: Secure storage cleared');
        }
      } catch (e, stackTrace) {
        // Log but don't fail - the app should still start
        AppLogger.instance.e(
          'Failed to clear secure storage on fresh install',
          error: e,
          stackTrace: stackTrace,
        );
      }

      // Mark that the app has now been run
      await prefs.setBool(_hasRunBeforeKey, true);

      return true;
    }

    return false;
  }
}
