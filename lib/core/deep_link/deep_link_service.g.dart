// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service for handling deep links and universal links.
///
/// Supports both:
/// - Custom URL schemes: `myapp://path`
/// - Universal Links/App Links: `https://example.com/path`
///
/// ## Setup Required:
///
/// ### Android (App Links)
/// 1. Add intent filters to AndroidManifest.xml (already configured)
/// 2. Host `assetlinks.json` at `https://yourdomain.com/.well-known/assetlinks.json`:
/// ```json
/// [{
///   "relation": ["delegate_permission/common.handle_all_urls"],
///   "target": {
///     "namespace": "android_app",
///     "package_name": "com.example.yourapp",
///     "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
///   }
/// }]
/// ```
///
/// ### iOS (Universal Links)
/// 1. Add Associated Domains entitlement (already configured in Runner.entitlements)
/// 2. Host `apple-app-site-association` at `https://yourdomain.com/.well-known/apple-app-site-association`:
/// ```json
/// {
///   "applinks": {
///     "apps": [],
///     "details": [{
///       "appID": "TEAMID.com.example.yourapp",
///       "paths": ["*"]
///     }]
///   }
/// }
/// ```
///
/// ## Usage:
/// ```dart
/// // The service automatically handles incoming links when initialized
/// // Links are processed and routed via GoRouter
///
/// // To manually get the initial link (if app was opened via link):
/// final initialUri = await ref.read(deepLinkServiceProvider.future);
/// ```

@ProviderFor(DeepLinkService)
final deepLinkServiceProvider = DeepLinkServiceProvider._();

/// Service for handling deep links and universal links.
///
/// Supports both:
/// - Custom URL schemes: `myapp://path`
/// - Universal Links/App Links: `https://example.com/path`
///
/// ## Setup Required:
///
/// ### Android (App Links)
/// 1. Add intent filters to AndroidManifest.xml (already configured)
/// 2. Host `assetlinks.json` at `https://yourdomain.com/.well-known/assetlinks.json`:
/// ```json
/// [{
///   "relation": ["delegate_permission/common.handle_all_urls"],
///   "target": {
///     "namespace": "android_app",
///     "package_name": "com.example.yourapp",
///     "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
///   }
/// }]
/// ```
///
/// ### iOS (Universal Links)
/// 1. Add Associated Domains entitlement (already configured in Runner.entitlements)
/// 2. Host `apple-app-site-association` at `https://yourdomain.com/.well-known/apple-app-site-association`:
/// ```json
/// {
///   "applinks": {
///     "apps": [],
///     "details": [{
///       "appID": "TEAMID.com.example.yourapp",
///       "paths": ["*"]
///     }]
///   }
/// }
/// ```
///
/// ## Usage:
/// ```dart
/// // The service automatically handles incoming links when initialized
/// // Links are processed and routed via GoRouter
///
/// // To manually get the initial link (if app was opened via link):
/// final initialUri = await ref.read(deepLinkServiceProvider.future);
/// ```
final class DeepLinkServiceProvider
    extends $AsyncNotifierProvider<DeepLinkService, Uri?> {
  /// Service for handling deep links and universal links.
  ///
  /// Supports both:
  /// - Custom URL schemes: `myapp://path`
  /// - Universal Links/App Links: `https://example.com/path`
  ///
  /// ## Setup Required:
  ///
  /// ### Android (App Links)
  /// 1. Add intent filters to AndroidManifest.xml (already configured)
  /// 2. Host `assetlinks.json` at `https://yourdomain.com/.well-known/assetlinks.json`:
  /// ```json
  /// [{
  ///   "relation": ["delegate_permission/common.handle_all_urls"],
  ///   "target": {
  ///     "namespace": "android_app",
  ///     "package_name": "com.example.yourapp",
  ///     "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
  ///   }
  /// }]
  /// ```
  ///
  /// ### iOS (Universal Links)
  /// 1. Add Associated Domains entitlement (already configured in Runner.entitlements)
  /// 2. Host `apple-app-site-association` at `https://yourdomain.com/.well-known/apple-app-site-association`:
  /// ```json
  /// {
  ///   "applinks": {
  ///     "apps": [],
  ///     "details": [{
  ///       "appID": "TEAMID.com.example.yourapp",
  ///       "paths": ["*"]
  ///     }]
  ///   }
  /// }
  /// ```
  ///
  /// ## Usage:
  /// ```dart
  /// // The service automatically handles incoming links when initialized
  /// // Links are processed and routed via GoRouter
  ///
  /// // To manually get the initial link (if app was opened via link):
  /// final initialUri = await ref.read(deepLinkServiceProvider.future);
  /// ```
  DeepLinkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepLinkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepLinkServiceHash();

  @$internal
  @override
  DeepLinkService create() => DeepLinkService();
}

String _$deepLinkServiceHash() => r'f1b672ba37fbcd167ff3e1e59f4af0d908f83df1';

/// Service for handling deep links and universal links.
///
/// Supports both:
/// - Custom URL schemes: `myapp://path`
/// - Universal Links/App Links: `https://example.com/path`
///
/// ## Setup Required:
///
/// ### Android (App Links)
/// 1. Add intent filters to AndroidManifest.xml (already configured)
/// 2. Host `assetlinks.json` at `https://yourdomain.com/.well-known/assetlinks.json`:
/// ```json
/// [{
///   "relation": ["delegate_permission/common.handle_all_urls"],
///   "target": {
///     "namespace": "android_app",
///     "package_name": "com.example.yourapp",
///     "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
///   }
/// }]
/// ```
///
/// ### iOS (Universal Links)
/// 1. Add Associated Domains entitlement (already configured in Runner.entitlements)
/// 2. Host `apple-app-site-association` at `https://yourdomain.com/.well-known/apple-app-site-association`:
/// ```json
/// {
///   "applinks": {
///     "apps": [],
///     "details": [{
///       "appID": "TEAMID.com.example.yourapp",
///       "paths": ["*"]
///     }]
///   }
/// }
/// ```
///
/// ## Usage:
/// ```dart
/// // The service automatically handles incoming links when initialized
/// // Links are processed and routed via GoRouter
///
/// // To manually get the initial link (if app was opened via link):
/// final initialUri = await ref.read(deepLinkServiceProvider.future);
/// ```

abstract class _$DeepLinkService extends $AsyncNotifier<Uri?> {
  FutureOr<Uri?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Uri?>, Uri?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Uri?>, Uri?>,
              AsyncValue<Uri?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider for checking if the app was launched from a deep link.

@ProviderFor(wasLaunchedFromDeepLink)
final wasLaunchedFromDeepLinkProvider = WasLaunchedFromDeepLinkProvider._();

/// Provider for checking if the app was launched from a deep link.

final class WasLaunchedFromDeepLinkProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider for checking if the app was launched from a deep link.
  WasLaunchedFromDeepLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wasLaunchedFromDeepLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wasLaunchedFromDeepLinkHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return wasLaunchedFromDeepLink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$wasLaunchedFromDeepLinkHash() =>
    r'853bb4942d07ab5fd16f2504fa041c81a44b76d0';
