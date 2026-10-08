import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/biometric/biometric_result.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'biometric_service.g.dart';

/// Provider for BiometricService.
@Riverpod(keepAlive: true)
BiometricService biometricService(Ref ref) => BiometricService(ref);

/// Provider for checking available biometric types.
@riverpod
Future<List<BiometricType>> availableBiometrics(Ref ref) async {
  return ref.watch(biometricServiceProvider).getAvailableBiometrics();
}

/// Provider for checking if biometric auth is available and enrolled.
@riverpod
Future<bool> canUseBiometrics(Ref ref) async {
  return ref.watch(biometricServiceProvider).isAvailable();
}

/// Provider for checking if user has enabled biometric auth in settings.
@riverpod
Future<bool> biometricEnabled(Ref ref) async {
  return ref.watch(biometricServiceProvider).isBiometricEnabled();
}

/// Biometric authentication service using local_auth.
class BiometricService {
  /// Creates a [BiometricService] instance.
  new(this._ref);

  final Ref _ref;
  final LocalAuthentication _auth = LocalAuthentication();

  AppLogger get _logger => _ref.read(loggerProvider);

  /// Check if biometric authentication is available on this device.
  Future<bool> isAvailable() async {
    try {
      final canAuth = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (!canAuth || !isSupported) return false;

      final biometrics = await _auth.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } on PlatformException catch (e) {
      _logger.e('Error checking biometric availability', error: e);
      return false;
    }
  }

  /// Get the list of available biometric types on this device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      _logger.e('Error getting available biometrics', error: e);
      return [];
    }
  }

  /// Check if the device has Face ID (iOS) or face recognition (Android).
  Future<bool> hasFaceId() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Check if the device has fingerprint/Touch ID.
  Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Authenticate the user using biometrics.
  Future<BiometricResult> authenticate({required String reason}) async {
    try {
      if (!await isAvailable()) return BiometricResult.notAvailable;

      final success = await _auth.authenticate(localizedReason: reason);
      _logger.d('Biometric auth ${success ? "success" : "failed"}');
      return success ? BiometricResult.success : BiometricResult.failed;
    } on PlatformException catch (e) {
      _logger.e('Biometric authentication error', error: e);
      return _handlePlatformException(e);
    }
  }

  /// Cancel any ongoing authentication.
  Future<bool> cancelAuthentication() async {
    try {
      return await _auth.stopAuthentication();
    } catch (e) {
      _logger.e('Error cancelling authentication', error: e);
      return false;
    }
  }

  /// Check if the user has enabled biometric authentication in app settings.
  Future<bool> isBiometricEnabled() async {
    final storage = _ref.read(secureStorageProvider);
    final value = await storage.read(key: biometricEnabledKey);
    return value == 'true';
  }

  /// Enable or disable biometric authentication preference.
  Future<void> setBiometricEnabled(bool enabled) async {
    final storage = _ref.read(secureStorageProvider);
    await storage.write(key: biometricEnabledKey, value: enabled.toString());
    _logger.d('Biometric preference set to: $enabled');
  }

  /// Authenticate if biometric is enabled, otherwise return success.
  Future<BiometricResult> authenticateIfEnabled({
    required String reason,
  }) async {
    if (!await isBiometricEnabled()) return BiometricResult.success;
    return authenticate(reason: reason);
  }

  BiometricResult _handlePlatformException(PlatformException e) =>
      switch (e.code) {
        'NotAvailable' => BiometricResult.notAvailable,
        'NotEnrolled' => BiometricResult.notEnrolled,
        'LockedOut' => BiometricResult.lockedOut,
        'PermanentlyLockedOut' => BiometricResult.permanentlyLockedOut,
        'PasscodeNotSet' => BiometricResult.noDeviceSecurity,
        'OtherOperatingSystem' => BiometricResult.notAvailable,
        _ when e.message?.contains('cancel') ?? false =>
          BiometricResult.cancelled,
        _ => BiometricResult.error,
      };
}
