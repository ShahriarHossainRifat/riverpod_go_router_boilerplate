import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';

/// BuildContext extension methods for common operations.
extension BuildContextExtensions on BuildContext {
  // ─────────────────────────────────────────────────────────────────────────────
  // THEME
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get the current theme data
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ─────────────────────────────────────────────────────────────────────────────
  // MEDIA QUERY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Get the current media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get the screen size
  Size get screenSize => mediaQuery.size;

  /// Get the screen width
  double get screenWidth => screenSize.width;

  /// Get the screen height
  double get screenHeight => screenSize.height;

  /// Get the view padding (safe area)
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Get the view insets (keyboard, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get the device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSIVE BREAKPOINTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Check if screen is mobile size (< 600)
  bool get isMobile => screenWidth < 600;

  /// Check if screen is tablet size (600 - 1024)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Check if screen is desktop size (>= 1024)
  bool get isDesktop => screenWidth >= 1024;

  /// Get responsive value based on screen size
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION (without GoRouter)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Pop the current route
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  // ─────────────────────────────────────────────────────────────────────────────
  // FOCUS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Unfocus the current focus node (dismiss keyboard)
  void unfocus() => FocusScope.of(this).unfocus();

  /// Request focus on a specific node
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  // ─────────────────────────────────────────────────────────────────────────────
  // SNACKBAR
  // ─────────────────────────────────────────────────────────────────────────────

  /// Show a snackbar with the given message
  void showSnackBar(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }

  /// Show an error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: colorScheme.error),
    );
  }

  /// Show a success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION (with Authentication Check)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Navigate to a route based on authentication status.
  ///
  /// If the user is authenticated, navigates to [authenticatedRoute].
  /// Otherwise, navigates to [unauthenticatedRoute] (typically login).
  ///
  /// **Requires [widgetRef]** - Pass the WidgetRef from your ConsumerWidget/HookConsumerWidget
  ///
  /// Example:
  /// ```dart
  /// context.pushRouteIfAuthenticatedElse(
  ///   widgetRef: ref,
  ///   authenticatedRoute: AppRoute.settings,
  ///   unauthenticatedRoute: AppRoute.login,
  /// );
  /// ```
  void pushRouteIfAuthenticatedElse({
    required WidgetRef widgetRef,
    required AppRoute authenticatedRoute,
    required AppRoute unauthenticatedRoute,
  }) {
    final isAuthenticated = widgetRef.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      push(authenticatedRoute.path);
    } else {
      go(unauthenticatedRoute.path);
    }
  }

  /// Navigate using [go] based on authentication status.
  ///
  /// Similar to [pushRouteIfAuthenticatedElse] but uses [go] for the
  /// authenticated route (replaces the current route stack).
  ///
  /// Example:
  /// ```dart
  /// context.goRouteIfAuthenticatedElse(
  ///   widgetRef: ref,
  ///   authenticatedRoute: AppRoute.home,
  ///   unauthenticatedRoute: AppRoute.login,
  /// );
  /// ```
  void goRouteIfAuthenticatedElse({
    required WidgetRef widgetRef,
    required AppRoute authenticatedRoute,
    required AppRoute unauthenticatedRoute,
  }) {
    final isAuthenticated = widgetRef.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      go(authenticatedRoute.path);
    } else {
      go(unauthenticatedRoute.path);
    }
  }

  /// Execute an action only if the user is authenticated.
  ///
  /// If authenticated, executes [action]. Otherwise, navigates to login.
  /// Useful for protecting actions that require authentication.
  ///
  /// **Requires [widgetRef]** - Pass the WidgetRef from your ConsumerWidget/HookConsumerWidget
  ///
  /// Example:
  /// ```dart
  /// context.executeIfAuthenticatedElse(
  ///   widgetRef: ref,
  ///   action: () => sendNotification(),
  ///   unauthenticatedRoute: AppRoute.login,
  /// );
  /// ```
  void executeIfAuthenticatedElse({
    required WidgetRef widgetRef,
    required VoidCallback action,
    required AppRoute unauthenticatedRoute,
  }) {
    final isAuthenticated = widgetRef.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      action();
    } else {
      go(unauthenticatedRoute.path);
    }
  }
}
