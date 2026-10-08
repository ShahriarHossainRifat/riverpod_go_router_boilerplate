import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/storage_keys.dart';
import 'package:riverpod_go_router_boilerplate/core/network/api_client.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Remote implementation of [AuthRepository].
///
/// This implementation makes actual API calls to your backend.
/// Use this in production environments.
///
/// Expects the following API endpoints:
/// - POST /auth/login - Login with email/password
/// - GET /auth/me - Get current user profile
/// - POST /auth/logout - Invalidate session (optional)
///
/// Expected response format for login:
/// ```json
/// {
///   "token": "jwt_token_here",
///   "refresh_token": "refresh_token_here", // optional
///   "user": {
///     "id": "user_id",
///     "email": "user@example.com",
///     "name": "User Name"
///   }
/// }
/// ```
class AuthRepositoryRemote implements AuthRepository {
  /// Creates a [AuthRepositoryRemote] instance.
  new({required this._apiClient, required this.secureStorage});

  final ApiClient _apiClient;

  /// Secure storage for storing tokens.
  final FlutterSecureStorage secureStorage;

  @override
  Future<Result<User>> login(String email, String password) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return switch (result) {
      Failure(:final error) => Failure(error),
      Success(:final data) => await _parseLoginResponse(data),
    };
  }

  Future<Result<User>> _parseLoginResponse(Map<String, dynamic> data) async {
    // Store tokens
    final token = data['token'] as String?;
    final refreshToken = data['refresh_token'] as String?;

    if (token != null) {
      await secureStorage.write(key: StorageKeys.accessToken, value: token);
    }
    if (refreshToken != null) {
      await secureStorage.write(
        key: StorageKeys.refreshToken,
        value: refreshToken,
      );
    }

    // Parse user
    final userData = data['user'] as Map<String, dynamic>?;
    if (userData == null) {
      return const Failure(
        AuthException(message: 'Invalid response: missing user data'),
      );
    }

    final user = User.fromJson(userData);
    await secureStorage.write(key: StorageKeys.userId, value: user.id);

    return Success(user);
  }

  @override
  Future<Result<User>> restoreSession() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);

    if (token == null) {
      return Failure(AuthException.noSession());
    }

    // Validate token by fetching current user
    final result = await _apiClient.get<Map<String, dynamic>>(
      '/auth/me',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    switch (result) {
      case Success(:final data):
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        return Success(User.fromJson(userData));
      case Failure(:final error):
        if (error is NetworkException && error.statusCode == 401) {
          await _clearTokens();
        }
        return Failure(error);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Optionally notify backend (ignore errors)
      await _apiClient.post<void>('/auth/logout');
    } catch (_) {
      // Ignore logout API errors - we still want to clear local state
    }

    return _clearTokens();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  Future<Result<void>> _clearTokens() async {
    try {
      await secureStorage.delete(key: StorageKeys.accessToken);
      await secureStorage.delete(key: StorageKeys.refreshToken);
      await secureStorage.delete(key: StorageKeys.userId);
      return const Success(null);
    } catch (e, stackTrace) {
      return Failure(
        CacheException(
          message: 'Failed to clear session',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
