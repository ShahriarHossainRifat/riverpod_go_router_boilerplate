// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crashlytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service for crash reporting using Firebase Crashlytics.
///
/// ## Setup Required:
///
/// 1. Create a Firebase project at https://console.firebase.google.com
/// 2. Add your Android and iOS apps to the Firebase project
/// 3. Download and add the configuration files:
///    - Android: `google-services.json` to `android/app/`
///    - iOS: `GoogleService-Info.plist` to `ios/Runner/`
/// 4. Run `flutterfire configure` to generate `firebase_options.dart`
///
/// ## Usage:
///
/// ```dart
/// // Record a non-fatal error
/// ref.read(crashlyticsServiceProvider).recordError(
///   exception,
///   stackTrace,
///   reason: 'API call failed',
/// );
///
/// // Log a message (appears in crash reports as breadcrumbs)
/// ref.read(crashlyticsServiceProvider).log('User tapped checkout button');
///
/// // Set user identifier for crash reports
/// ref.read(crashlyticsServiceProvider).setUserId('user_123');
///
/// // Set custom keys for debugging
/// ref.read(crashlyticsServiceProvider).setCustomKey('screen', 'checkout');
/// ```
///
/// ## Features:
/// - Automatic crash reporting (fatal errors)
/// - Manual error recording (non-fatal errors)
/// - Custom log messages as breadcrumbs
/// - User identification
/// - Custom key-value pairs for debugging
/// - Respects user privacy (can be disabled)

@ProviderFor(crashlyticsService)
final crashlyticsServiceProvider = CrashlyticsServiceProvider._();

/// Service for crash reporting using Firebase Crashlytics.
///
/// ## Setup Required:
///
/// 1. Create a Firebase project at https://console.firebase.google.com
/// 2. Add your Android and iOS apps to the Firebase project
/// 3. Download and add the configuration files:
///    - Android: `google-services.json` to `android/app/`
///    - iOS: `GoogleService-Info.plist` to `ios/Runner/`
/// 4. Run `flutterfire configure` to generate `firebase_options.dart`
///
/// ## Usage:
///
/// ```dart
/// // Record a non-fatal error
/// ref.read(crashlyticsServiceProvider).recordError(
///   exception,
///   stackTrace,
///   reason: 'API call failed',
/// );
///
/// // Log a message (appears in crash reports as breadcrumbs)
/// ref.read(crashlyticsServiceProvider).log('User tapped checkout button');
///
/// // Set user identifier for crash reports
/// ref.read(crashlyticsServiceProvider).setUserId('user_123');
///
/// // Set custom keys for debugging
/// ref.read(crashlyticsServiceProvider).setCustomKey('screen', 'checkout');
/// ```
///
/// ## Features:
/// - Automatic crash reporting (fatal errors)
/// - Manual error recording (non-fatal errors)
/// - Custom log messages as breadcrumbs
/// - User identification
/// - Custom key-value pairs for debugging
/// - Respects user privacy (can be disabled)

final class CrashlyticsServiceProvider
    extends
        $FunctionalProvider<
          CrashlyticsService,
          CrashlyticsService,
          CrashlyticsService
        >
    with $Provider<CrashlyticsService> {
  /// Service for crash reporting using Firebase Crashlytics.
  ///
  /// ## Setup Required:
  ///
  /// 1. Create a Firebase project at https://console.firebase.google.com
  /// 2. Add your Android and iOS apps to the Firebase project
  /// 3. Download and add the configuration files:
  ///    - Android: `google-services.json` to `android/app/`
  ///    - iOS: `GoogleService-Info.plist` to `ios/Runner/`
  /// 4. Run `flutterfire configure` to generate `firebase_options.dart`
  ///
  /// ## Usage:
  ///
  /// ```dart
  /// // Record a non-fatal error
  /// ref.read(crashlyticsServiceProvider).recordError(
  ///   exception,
  ///   stackTrace,
  ///   reason: 'API call failed',
  /// );
  ///
  /// // Log a message (appears in crash reports as breadcrumbs)
  /// ref.read(crashlyticsServiceProvider).log('User tapped checkout button');
  ///
  /// // Set user identifier for crash reports
  /// ref.read(crashlyticsServiceProvider).setUserId('user_123');
  ///
  /// // Set custom keys for debugging
  /// ref.read(crashlyticsServiceProvider).setCustomKey('screen', 'checkout');
  /// ```
  ///
  /// ## Features:
  /// - Automatic crash reporting (fatal errors)
  /// - Manual error recording (non-fatal errors)
  /// - Custom log messages as breadcrumbs
  /// - User identification
  /// - Custom key-value pairs for debugging
  /// - Respects user privacy (can be disabled)
  CrashlyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashlyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashlyticsServiceHash();

  @$internal
  @override
  $ProviderElement<CrashlyticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CrashlyticsService create(Ref ref) {
    return crashlyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrashlyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrashlyticsService>(value),
    );
  }
}

String _$crashlyticsServiceHash() =>
    r'4c7c67566736b6b465835b9cbf8321941eedf632';
