// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

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

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
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
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'9356d0fef4c2be37e533cedbe96d26fb57d78fe4';
