import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'deep_link_service.g.dart';

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
@Riverpod(keepAlive: true)
class DeepLinkService extends _$DeepLinkService {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  FutureOr<Uri?> build() async {
    _appLinks = AppLinks();

    // Start listening for incoming links
    _startLinkListener();

    // Handle disposal
    ref.onDispose(_dispose);

    // Return the initial link (if app was opened via deep link)
    return _getInitialLink();
  }

  /// Get the initial link that launched the app.
  Future<Uri?> _getInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _logger.i('App launched with deep link: $initialUri');
        _handleDeepLink(initialUri);
      }
      return initialUri;
    } catch (e, stack) {
      _logger.e('Error getting initial link', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Start listening for incoming links while app is running.
  void _startLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _logger.i('Received deep link while running: $uri');
        _handleDeepLink(uri);
      },
      onError: (Object error) {
        _logger.e('Deep link stream error', error: error);
      },
    );
  }

  /// Handle an incoming deep link by routing to the appropriate screen.
  void _handleDeepLink(Uri uri) {
    // Convert the deep link to an app route
    final path = _convertToAppPath(uri);

    if (path != null) {
      // Use the router to navigate
      final router = ref.read(appRouterProvider);
      router.go(path);
      _logger.d('Navigated to: $path');
    } else {
      _logger.w('Unknown deep link path: ${uri.path}');
    }
  }

  /// Convert a deep link URI to an app path.
  ///
  /// Handles both custom schemes and HTTPS URLs:
  /// - `myapp://product/123` → `/product/123`
  /// - `https://example.com/product/123` → `/product/123`
  String? _convertToAppPath(Uri uri) {
    // For custom schemes: myapp://product/123
    // The path is already what we need
    if (uri.scheme == 'myapp') {
      // Handle root path
      if (uri.host.isEmpty && uri.path.isEmpty) {
        return AppRoute.home.path;
      }
      // For myapp://home, host is 'home' and path is empty
      // For myapp://product/123, host is 'product' and path is '/123'
      if (uri.path.isEmpty || uri.path == '/') {
        return '/${uri.host}';
      }
      return '/${uri.host}${uri.path}';
    }

    // For HTTPS URLs: https://example.com/product/123
    // Just use the path
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return uri.path.isEmpty ? AppRoute.home.path : uri.path;
    }

    return uri.path.isEmpty ? null : uri.path;
  }

  void _dispose() {
    _linkSubscription?.cancel();
  }

  AppLogger get _logger => ref.read(loggerProvider);
}

/// Provider for checking if the app was launched from a deep link.
@riverpod
bool wasLaunchedFromDeepLink(Ref ref) {
  final deepLinkState = ref.watch(deepLinkServiceProvider);
  return deepLinkState.value != null;
}
