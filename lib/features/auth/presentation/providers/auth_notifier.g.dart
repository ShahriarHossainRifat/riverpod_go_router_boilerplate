// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

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
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, User?> {
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
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'8c700fb4c3df844037d7a95d5f88416129261528';

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

abstract class _$AuthNotifier extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Convenience provider for checking authentication status from auth state.
///
/// Prefer [isAuthenticatedProvider] from session_service.dart for most uses.
/// This provider reads directly from the auth AsyncValue.
///
/// Usage: `ref.watch(authIsAuthenticatedProvider)`

@ProviderFor(authIsAuthenticated)
final authIsAuthenticatedProvider = AuthIsAuthenticatedProvider._();

/// Convenience provider for checking authentication status from auth state.
///
/// Prefer [isAuthenticatedProvider] from session_service.dart for most uses.
/// This provider reads directly from the auth AsyncValue.
///
/// Usage: `ref.watch(authIsAuthenticatedProvider)`

final class AuthIsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Convenience provider for checking authentication status from auth state.
  ///
  /// Prefer [isAuthenticatedProvider] from session_service.dart for most uses.
  /// This provider reads directly from the auth AsyncValue.
  ///
  /// Usage: `ref.watch(authIsAuthenticatedProvider)`
  AuthIsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authIsAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authIsAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return authIsAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authIsAuthenticatedHash() =>
    r'50d23b87d66d8f0d4763cdc897672834f375b39e';

/// Convenience provider for getting the current authenticated user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentAuthUserProvider)`

@ProviderFor(currentAuthUser)
final currentAuthUserProvider = CurrentAuthUserProvider._();

/// Convenience provider for getting the current authenticated user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentAuthUserProvider)`

final class CurrentAuthUserProvider
    extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// Convenience provider for getting the current authenticated user.
  ///
  /// Returns null if not authenticated or loading.
  /// Usage: `ref.watch(currentAuthUserProvider)`
  CurrentAuthUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAuthUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAuthUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentAuthUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentAuthUserHash() => r'1be215db5ca1afd1cde7b4b7c46fa9b6ee210eb5';
