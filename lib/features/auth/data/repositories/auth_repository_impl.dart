/// Auth repository implementations.
///
/// This layer provides concrete implementations of the `AuthRepository` interface.
/// See `auth_repository_provider.dart` for the Riverpod provider.
///
/// ## Available implementations:
/// - `AuthRepositoryMock`: Mock implementation for development and testing
/// - `AuthRepositoryRemote`: Real implementation making API calls to backend
///
/// The `authRepositoryProvider` in `auth_repository_provider.dart` automatically
/// selects the appropriate implementation based on `EnvConfig.useMockRepositories`.
library;

export 'auth_repository_mock.dart';
export 'auth_repository_provider.dart';
export 'auth_repository_remote.dart';
