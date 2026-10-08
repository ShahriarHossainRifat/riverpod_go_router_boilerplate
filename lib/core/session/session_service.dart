import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session_state.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/auth.dart';

/// Provider that exposes the current session state reactively.
///
/// Use this when you need to watch session state changes.
/// This is the single source of truth for session state.
final sessionStateProvider = Provider<SessionState>((ref) {
  final authState = ref.watch(authProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return const SessionInactive();
      }
      return SessionActive(userId: user.id);
    },
    loading: () => const SessionLoading(),
    error: (error, _) {
      if (error is AuthException) {
        return SessionExpired(reason: error.message);
      }
      return const SessionInactive();
    },
  );
});

/// Provider that indicates whether user is authenticated.
///
/// Simple boolean for convenience in guards and conditionals.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(sessionStateProvider).isAuthenticated;
});

/// Callback type for invalidating user-specific providers on logout.
///
/// Implement this to clear any cached user data when the session ends.
typedef InvalidateProvidersCallback = void Function(Ref ref);

/// Service for session operations.
///
/// Use [sessionStateProvider] for reactive state.
/// Use this service for imperative operations like ending session.
///
/// ## Provider Invalidation on Logout
///
/// Register callbacks to invalidate user-specific providers on logout:
/// ```dart
/// final sessionService = ref.read(sessionServiceProvider);
/// sessionService.addLogoutCallback((ref) {
///   ref.invalidate(userProfileProvider);
///   ref.invalidate(userSettingsProvider);
/// });
/// ```
class SessionService {
  /// Creates a [SessionService].
  new(this._ref);

  final Ref _ref;

  /// Registered callbacks to invalidate user-specific providers on logout.
  ///
  /// Use [addLogoutCallback] to register a callback.
  /// All callbacks are called in registration order when [endSession] is called.
  final List<InvalidateProvidersCallback> _logoutCallbacks = [];

  /// Register a callback to invalidate user-specific providers on logout.
  ///
  /// Multiple callbacks can be registered. All are called in order on logout.
  /// This is preferred over a single mutable callback as it:
  /// - Supports multiple feature modules registering independent cleanup
  /// - Cannot accidentally be unset
  ///
  /// Example:
  /// ```dart
  /// sessionService.addLogoutCallback((ref) {
  ///   ref.invalidate(userProfileProvider);
  ///   ref.invalidate(notificationsProvider);
  /// });
  /// ```
  void addLogoutCallback(InvalidateProvidersCallback callback) {
    _logoutCallbacks.add(callback);
  }

  /// Remove a previously registered logout callback.
  void removeLogoutCallback(InvalidateProvidersCallback callback) {
    _logoutCallbacks.remove(callback);
  }

  /// Get the current session state (non-reactive).
  SessionState get currentState => _ref.read(sessionStateProvider);

  /// Check if the current session is valid.
  Future<bool> validateSession() async {
    final state = currentState;
    if (state is SessionActive) {
      return !state.isExpiringSoon;
    }
    return false;
  }

  /// End the current session (logout).
  ///
  /// This will:
  /// 1. Call all registered [addLogoutCallback] callbacks to clear cached user data
  /// 2. Call the auth notifier to perform logout
  ///
  /// Any cached user data will be cleared to ensure a clean state.
  Future<void> endSession() async {
    // Invalidate all user-specific cached data via registered callbacks
    for (final callback in _logoutCallbacks) {
      callback(_ref);
    }

    // Then perform the actual logout
    final notifier = _ref.read(authProvider.notifier);
    await notifier.logout();
  }
}

/// Provider for the SessionService.
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref);
});
