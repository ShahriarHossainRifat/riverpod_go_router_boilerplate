import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

part 'auth_notifier.g.dart';

/// Manages authentication state.
///
/// Use this to:
/// - Check if user is logged in
/// - Login/logout
/// - Access current user
///
/// ## Why `keepAlive: true`?
///
/// Auth state should persist for the entire app lifecycle because:
/// - Auth state is needed across all screens for route guards
/// - Prevents unnecessary session restoration on every navigation
/// - Session should survive screen transitions
///
/// **Note:** Most presentation-layer providers (ViewModels, page-specific notifiers)
/// should NOT use `keepAlive: true`. Use `autoDispose` (default) to free memory
/// when the user navigates away. Only use `keepAlive` for:
/// - Global app state (auth, theme, user preferences)
/// - Expensive services (network clients, database connections)
/// - State that must survive navigation (audio player, download manager)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);

    final result = await _repo.restoreSession();
    return result.dataOrNull;
  }

  /// Attempt to login with credentials.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _repo.login(email, password);

    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (error) => AsyncError(error, StackTrace.current),
    );

    // Track login event (success or failure)
    if (state.value != null) {
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.login);
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    final result = await _repo.logout();

    result.fold(
      onSuccess: (_) {
        state = const AsyncData(null);
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.logout);
      },
      onFailure: (error) {
        // Still clear local state even if server logout fails
        state = const AsyncData(null);
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.logout);
        if (kDebugMode) {
          debugPrint('Logout error: ${error.message}');
        }
      },
    );
  }

  /// Check if user is currently authenticated.
  bool get isAuthenticated => state.value != null;

  /// Get the current user, or null if not authenticated.
  User? get currentUser => state.value;
}

/// Convenience provider for checking authentication status from auth state.
///
/// Prefer [isAuthenticatedProvider] from session_service.dart for most uses.
/// This provider reads directly from the auth AsyncValue.
///
/// Usage: `ref.watch(authIsAuthenticatedProvider)`
@riverpod
bool authIsAuthenticated(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.value != null;
}

/// Convenience provider for getting the current authenticated user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentAuthUserProvider)`
@riverpod
User? currentAuthUser(Ref ref) {
  return ref.watch(authProvider).value;
}
