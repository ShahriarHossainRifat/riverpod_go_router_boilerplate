import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/presentation/pages/error_page.dart';
import 'package:riverpod_go_router_boilerplate/app/router/auth_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/protected_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/splash_route.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_state.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

part 'app_router.g.dart';

// ============================================================================
// Route Definitions (Enum-based for compile-time safety)
// ============================================================================

/// All app routes defined as an enum for type safety.
///
/// Benefits over string constants:
/// - Compile-time safety: typos are caught by the compiler
/// - IDE autocomplete: easy to discover available routes
/// - Exhaustive switch: compiler warns if you miss a case
/// - Additional metadata: each route carries its properties
///
/// Usage:
/// ```dart
/// // Navigate using the path
/// context.go(AppRoute.home.path);
///
/// // Or use the extension method
/// context.goRoute(AppRoute.home);
///
/// // Dynamic routes with parameters
/// context.go(AppRoute.productDetail.pathWith({'id': '123'}));
/// // -> '/product/123'
///
/// // Check if route requires auth
/// if (AppRoute.settings.requiresAuth) { ... }
/// ```
enum AppRoute {
  /// Splash screen shown during app initialization.
  splash('/splash', requiresAuth: false),

  /// Login screen for user authentication.
  login('/login', requiresAuth: false),

  /// Home screen shown after successful login.
  home('/', requiresAuth: true),

  /// Onboarding screen shown to new users.
  onboarding('/onboarding', requiresAuth: false),

  /// Maintenance screen shown during downtime.
  maintenance('/maintenance', requiresAuth: false),

  /// Force update screen shown when app version is too old.
  forceUpdate('/force-update', requiresAuth: false),

  /// User profile screen.
  profile('/profile', requiresAuth: true),

  /// Settings screen for user preferences.
  settings('/settings', requiresAuth: true)
  // Example dynamic routes (uncomment and customize as needed):
  // productDetail('/product/:id', requiresAuth: true),
  // userProfile('/user/:userId', requiresAuth: true),
  // orderDetail('/order/:orderId', requiresAuth: true),
  ;

  new(this.path, {required this.requiresAuth});

  /// The URL path pattern for this route.
  /// May contain path parameters prefixed with ':' (e.g., '/product/:id').
  final String path;

  /// Whether this route requires authentication.
  final bool requiresAuth;

  /// Generate a path with the given parameters substituted.
  ///
  /// Example:
  /// ```dart
  /// // For route: productDetail('/product/:id', ...)
  /// AppRoute.productDetail.pathWith({'id': '123'});
  /// // Returns: '/product/123'
  ///
  /// // Multiple params: '/order/:orderId/item/:itemId'
  /// route.pathWith({'orderId': '456', 'itemId': '789'});
  /// // Returns: '/order/456/item/789'
  /// ```
  ///
  /// Throws [ArgumentError] if a required parameter is missing.
  String pathWith(Map<String, String> params) {
    var result = path;
    final paramPattern = RegExp(r':(\w+)');
    final matches = paramPattern.allMatches(path);

    for (final match in matches) {
      final paramName = match.group(1)!;
      final value = params[paramName];
      if (value == null) {
        throw ArgumentError(
          'Missing required path parameter "$paramName" for route $name',
        );
      }
      result = result.replaceFirst(':$paramName', value);
    }

    return result;
  }

  /// Check if this route has path parameters.
  bool get hasPathParams => path.contains(':');

  /// Get the list of path parameter names for this route.
  ///
  /// Example:
  /// ```dart
  /// // For route: '/order/:orderId/item/:itemId'
  /// route.pathParamNames; // ['orderId', 'itemId']
  /// ```
  List<String> get pathParamNames {
    final paramPattern = RegExp(r':(\w+)');
    return paramPattern.allMatches(path).map((m) => m.group(1)!).toList();
  }

  /// Get a route by its path pattern, or null if not found.
  ///
  /// Note: For dynamic routes, pass the pattern (e.g., '/product/:id'),
  /// not the resolved path (e.g., '/product/123').
  static AppRoute? fromPath(String path) {
    for (final route in values) {
      if (route.path == path) return route;
    }
    return null;
  }

  /// Match a resolved path to a route, handling path parameters.
  ///
  /// Example:
  /// ```dart
  /// AppRoute.matchPath('/product/123'); // Returns AppRoute.productDetail
  /// AppRoute.matchPath('/settings');    // Returns AppRoute.settings
  /// ```
  static AppRoute? matchPath(String resolvedPath) {
    for (final route in values) {
      if (_matchesPattern(route.path, resolvedPath)) {
        return route;
      }
    }
    return null;
  }

  /// Check if a resolved path matches a route pattern.
  static bool _matchesPattern(String pattern, String path) {
    // Convert pattern to regex: '/product/:id' -> '^/product/([^/]+)$'
    final regexPattern = pattern.replaceAllMapped(
      RegExp(r':(\w+)'),
      (_) => '([^/]+)',
    );
    return RegExp('^$regexPattern\$').hasMatch(path);
  }

  /// All routes that require authentication.
  static List<AppRoute> get protectedRoutes =>
      values.where((r) => r.requiresAuth).toList();

  /// All public routes (no auth required).
  static List<AppRoute> get publicRoutes =>
      values.where((r) => !r.requiresAuth).toList();
}

/// Extension for convenient navigation with [AppRoute] enum.
extension AppRouteNavigation on BuildContext {
  /// Navigate to a route using [GoRouter.go].
  void goRoute(AppRoute route) => go(route.path);

  /// Navigate to a route with parameters using [GoRouter.go].
  ///
  /// Example:
  /// ```dart
  /// context.goRouteWith(AppRoute.productDetail, {'id': '123'});
  /// ```
  void goRouteWith(AppRoute route, Map<String, String> params) =>
      go(route.pathWith(params));

  /// Navigate to a route using [GoRouter.push].
  void pushRoute(AppRoute route) => push(route.path);

  /// Navigate to a route with parameters using [GoRouter.push].
  void pushRouteWith(AppRoute route, Map<String, String> params) =>
      push(route.pathWith(params));

  /// Replace current route using [GoRouter.pushReplacement].
  void pushReplacementRoute(AppRoute route) => pushReplacement(route.path);

  /// Replace current route with parameters using [GoRouter.pushReplacement].
  void pushReplacementRouteWith(AppRoute route, Map<String, String> params) =>
      pushReplacement(route.pathWith(params));
}

/// Global navigator key for accessing navigation outside of widget context.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the app router.
///
/// Uses [appLifecycleListenableProvider] to refresh when lifecycle state changes.
/// Also watches [sessionStateProvider] for immediate redirection on auth changes.
/// This enables reactive routing based on session state, maintenance mode, etc.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Watch lifecycle state for initialization/maintenance transitions
  final lifecycleListenable = ref.watch(appLifecycleListenableProvider);

  // Watch session state for immediate auth changes (login/logout)
  // This ensures we redirect to login immediately when user logs out
  ref.watch(sessionStateProvider);

  // Get analytics observer for screen tracking
  final analyticsObserver = ref.watch(analyticsObserverProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: lifecycleListenable,
    routes: [splashRoute, ...authRoutes, ...protectedRoutes],
    redirect: (context, state) => _handleRedirect(ref, state.uri.path),
    errorBuilder: (context, state) => ErrorPage(path: state.uri.path),
    observers: [
      // Performance monitoring for screen traces
      PerformanceRouteObserver(ref),
      // Analytics for screen view tracking
      ?analyticsObserver,
    ],
  );
}

// ============================================================================
// Redirect Guards (Chain of Responsibility Pattern)
// ============================================================================

/// Main redirect handler - delegates to specific guards.
String? _handleRedirect(Ref ref, String path) {
  final lifecycleState = ref.read(appLifecycleNotifierProvider);
  final sessionState = ref.read(sessionStateProvider);
  final startupState = ref.read(currentStartupStateProvider);
  // Use matchPath to handle dynamic routes (e.g., '/product/123')
  final route = AppRoute.matchPath(path);

  // Apply guards in order of priority
  return _guardLoading(route, sessionState) ??
      _guardInitialization(route, lifecycleState) ??
      _guardMaintenance(route, startupState) ??
      _guardForceUpdate(route, startupState) ??
      _guardSplash(route) ??
      _guardAuth(route, sessionState);
}

/// Guard: Hold all navigation on splash while session is loading.
/// Prevents flash of unauthenticated content on deep links before session restore.
String? _guardLoading(AppRoute? route, SessionState sessionState) {
  if (sessionState.isLoading && route != AppRoute.splash) {
    return AppRoute.splash.path;
  }
  return null;
}

/// Guard: Force splash until initialization completes.
/// Prevents "flash of unauthenticated content" when deep links arrive
/// before session state is restored from storage.
String? _guardInitialization(
  AppRoute? route,
  AppLifecycleState lifecycleState,
) {
  if (!lifecycleState.isInitialized) {
    if (route != AppRoute.splash) {
      return AppRoute.splash.path; // Force back to splash
    }
    return null; // Stay on splash
  }
  return null;
}

/// Guard: Redirect to maintenance page when app is in maintenance mode.
/// Allows access only to the maintenance page itself during downtime.
String? _guardMaintenance(AppRoute? route, StartupState startupState) {
  if (startupState is MaintenanceState) {
    if (route != AppRoute.maintenance) {
      return AppRoute.maintenance.path;
    }
    return null;
  }
  // Not in maintenance - don't allow direct navigation to maintenance page
  if (route == AppRoute.maintenance) {
    return AppRoute.home.path;
  }
  return null;
}

/// Guard: Redirect to force update page when app requires an update.
String? _guardForceUpdate(AppRoute? route, StartupState startupState) {
  if (startupState is ForceUpdateState) {
    if (route != AppRoute.forceUpdate) {
      return AppRoute.forceUpdate.path;
    }
    return null;
  }
  if (route == AppRoute.forceUpdate) {
    return AppRoute.home.path;
  }
  return null;
}

/// Guard: Allow splash to handle its own routing.
String? _guardSplash(AppRoute? route) {
  if (route == AppRoute.splash) {
    return null; // Splash handles navigation after init
  }
  return null;
}

/// Guard: Handle authentication-based redirects.
String? _guardAuth(AppRoute? route, SessionState sessionState) {
  if (!AppConfig.authEnabled || route == null) {
    return null; // Auth disabled or unknown route, allow
  }

  final isLoggedIn = sessionState.isAuthenticated;

  // Use the enum's requiresAuth property for cleaner logic
  if (route.requiresAuth && !isLoggedIn) {
    return AppRoute.login.path;
  }

  // Redirect authenticated users away from login
  if (isLoggedIn && route == AppRoute.login) {
    return AppRoute.home.path;
  }

  return null;
}
