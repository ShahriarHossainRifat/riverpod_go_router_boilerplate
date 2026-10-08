import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// Provider for secure storage instance.
///
/// Use this for storing sensitive data like tokens, API keys, and credentials.
/// Configured with platform-specific security options:
///
/// **iOS:**
/// - Uses Keychain with `first_unlock_this_device` accessibility
/// - Data is available after first device unlock
/// - Data is NOT backed up to iCloud
///
/// **Android:**
/// - Uses encrypted shared preferences with AES encryption
/// - Keys are stored in Android Keystore
/// - Reset on device lock settings change (encryptedSharedPreferences: true)
///
/// **Important:** Never store unencrypted sensitive data. Always use this
/// provider for tokens, passwords, and other credentials.
///
/// **Usage:**
/// ```dart
/// final storage = ref.read(secureStorageProvider);
/// await storage.write(key: StorageKeys.accessToken, value: token);
/// final token = await storage.read(key: StorageKeys.accessToken);
/// ```
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    // Linux uses libsecret, macOS uses Keychain, Web uses encrypted localStorage
  );
}
