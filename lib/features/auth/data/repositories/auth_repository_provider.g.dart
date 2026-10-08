// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the auth repository.
///
/// Automatically switches between mock and remote implementation
/// based on the current environment:
/// - Development/Staging: Uses [AuthRepositoryMock]
/// - Production: Uses [AuthRepositoryRemote]
///
/// ## Testing
/// Override this provider in tests for isolation:
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(MockAuthRepository()),
///   ],
///   child: MyApp(),
/// )
/// ```
///
/// ## Forcing specific implementation
/// You can also override the underlying implementation providers:
/// ```dart
/// // Force mock in production for debugging
/// authRepositoryProvider.overrideWith((ref) => AuthRepositoryMock(...))
/// ```

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Provider for the auth repository.
///
/// Automatically switches between mock and remote implementation
/// based on the current environment:
/// - Development/Staging: Uses [AuthRepositoryMock]
/// - Production: Uses [AuthRepositoryRemote]
///
/// ## Testing
/// Override this provider in tests for isolation:
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(MockAuthRepository()),
///   ],
///   child: MyApp(),
/// )
/// ```
///
/// ## Forcing specific implementation
/// You can also override the underlying implementation providers:
/// ```dart
/// // Force mock in production for debugging
/// authRepositoryProvider.overrideWith((ref) => AuthRepositoryMock(...))
/// ```

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Provider for the auth repository.
  ///
  /// Automatically switches between mock and remote implementation
  /// based on the current environment:
  /// - Development/Staging: Uses [AuthRepositoryMock]
  /// - Production: Uses [AuthRepositoryRemote]
  ///
  /// ## Testing
  /// Override this provider in tests for isolation:
  /// ```dart
  /// ProviderScope(
  ///   overrides: [
  ///     authRepositoryProvider.overrideWithValue(MockAuthRepository()),
  ///   ],
  ///   child: MyApp(),
  /// )
  /// ```
  ///
  /// ## Forcing specific implementation
  /// You can also override the underlying implementation providers:
  /// ```dart
  /// // Force mock in production for debugging
  /// authRepositoryProvider.overrideWith((ref) => AuthRepositoryMock(...))
  /// ```
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'd92445e98ca52edc50c6fcf8a9184c1a0d152bfd';
