// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the app router.
///
/// Uses [appLifecycleListenableProvider] to refresh when lifecycle state changes.
/// Also watches [sessionStateProvider] for immediate redirection on auth changes.
/// This enables reactive routing based on session state, maintenance mode, etc.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Provider for the app router.
///
/// Uses [appLifecycleListenableProvider] to refresh when lifecycle state changes.
/// Also watches [sessionStateProvider] for immediate redirection on auth changes.
/// This enables reactive routing based on session state, maintenance mode, etc.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provider for the app router.
  ///
  /// Uses [appLifecycleListenableProvider] to refresh when lifecycle state changes.
  /// Also watches [sessionStateProvider] for immediate redirection on auth changes.
  /// This enables reactive routing based on session state, maintenance mode, etc.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'95f16d2c86f774dd14052b851e50a47fc55fae3b';
