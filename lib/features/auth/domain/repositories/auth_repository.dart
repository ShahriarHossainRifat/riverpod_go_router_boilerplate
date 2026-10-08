import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';

/// Contract for authentication operations.
/// Implemented by `AuthRepositoryRemote` and `AuthRepositoryMock` in the data layer.
abstract interface class AuthRepository {
  /// Attempt to login with email and password.
  Future<Result<User>> login(String email, String password);

  /// Restore session from stored credentials.
  Future<Result<User>> restoreSession();

  /// Clear the current session and logout.
  Future<Result<void>> logout();

  /// Check if user is currently authenticated.
  Future<bool> isAuthenticated();
}
