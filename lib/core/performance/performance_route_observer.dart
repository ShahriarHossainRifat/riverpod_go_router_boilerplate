import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/performance/performance_service.dart';

/// Route observer that tracks screen rendering performance.
///
/// Automatically creates screen traces when navigating between routes.
/// This helps identify slow screens and optimize user experience.
///
/// ## Usage:
///
/// Add to your GoRouter configuration:
/// ```dart
/// GoRouter(
///   observers: [
///     PerformanceRouteObserver(ref),
///   ],
///   // ...
/// )
/// ```
///
/// ## What's Tracked:
/// - Screen name (route path)
/// - Time spent on each screen
/// - Screen render duration
///
/// ## Best Practices:
/// - Use meaningful route names in GoRouter
/// - Avoid generic names like 'page' or 'screen'
class PerformanceRouteObserver extends NavigatorObserver {
  /// Creates a [PerformanceRouteObserver] instance.
  new(this._ref);

  final Ref _ref;

  /// Map of route names to their traces.
  final Map<String, Trace> _activeTraces = {};

  PerformanceService get _performanceService =>
      _ref.read(performanceServiceProvider);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _startScreenTrace(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _stopScreenTrace(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      _stopScreenTrace(oldRoute);
    }
    if (newRoute != null) {
      _startScreenTrace(newRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _stopScreenTrace(route);
  }

  Future<void> _startScreenTrace(Route<dynamic> route) async {
    if (!_performanceService.isEnabled) return;

    final screenName = _getScreenName(route);
    if (screenName == null) return;

    final trace = await _performanceService.startTrace('screen_$screenName');
    if (trace != null) {
      trace.putAttribute('screen_name', screenName);
      _activeTraces[screenName] = trace;
    }
  }

  Future<void> _stopScreenTrace(Route<dynamic> route) async {
    final screenName = _getScreenName(route);
    if (screenName == null) return;

    final trace = _activeTraces.remove(screenName);
    await trace?.stop();
  }

  String? _getScreenName(Route<dynamic> route) {
    // Try to get a meaningful name from the route
    final settings = route.settings;
    final name = settings.name;

    if (name == null || name.isEmpty || name == '/') {
      return null;
    }

    // Clean up the route name
    // Remove leading slash and replace remaining slashes with underscores
    return name
        .replaceFirst(RegExp('^/'), '')
        .replaceAll('/', '_')
        .replaceAll(RegExp('[^a-zA-Z0-9_]'), '');
  }
}
