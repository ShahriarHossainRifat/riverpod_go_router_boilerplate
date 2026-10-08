import 'package:flutter/foundation.dart' show immutable;

/// A type-safe Result monad for handling success/failure outcomes.
///
/// Use this instead of throwing exceptions for expected failures.
/// This provides compile-time safety and forces callers to handle both cases.
///
/// ## Why Use Result?
///
/// - **Explicit error handling**: Callers must acknowledge the possibility of failure
/// - **No hidden control flow**: Unlike exceptions, errors don't bypass normal code flow
/// - **Type safety**: Both success and failure types are known at compile time
/// - **Composability**: Chain operations with [map], [flatMap], and [fold]
///
/// ## Basic Usage
///
/// ```dart
/// Future<Result<User>> fetchUser(String id) async {
///   try {
///     final response = await api.get('/users/$id');
///     return Success(User.fromJson(response.data));
///   } on DioException catch (e) {
///     return Failure(NetworkException(message: e.message ?? 'Network error'));
///   }
/// }
///
/// // Handle the result
/// final result = await fetchUser('123');
/// result.fold(
///   onSuccess: (user) => showUser(user),
///   onFailure: (error) => showError(error.message),
/// );
/// ```
///
/// ## Chaining Operations
///
/// ```dart
/// final result = await fetchUser('123')
///   .flatMap((user) => fetchProfile(user.id))
///   .map((profile) => profile.displayName);
/// ```
@immutable
sealed class Result<T> {
  const new();

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the data if [Success], otherwise returns null.
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Returns the error if [Failure], otherwise returns null.
  AppException? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  /// Pattern match on the result.
  ///
  /// ```dart
  /// final result = await repository.fetchUser();
  /// result.fold(
  ///   onSuccess: (user) => print(user.name),
  ///   onFailure: (error) => print(error.message),
  /// );
  /// ```
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Failure(:final error) => onFailure(error),
    };
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Failure(:final error) => Failure(error),
    };
  }

  /// Chain another Result-returning operation.
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(:final data) => transform(data),
      Failure(:final error) => Failure(error),
    };
  }

  /// Returns the data or throws the error.
  ///
  /// ⚠️ **WARNING:** Use with extreme caution!
  ///
  /// This method defeats the purpose of the Result type by introducing
  /// unchecked exceptions. Only use in scenarios where:
  /// - You have already checked [isSuccess] beforehand
  /// - You're in test code where failing fast is acceptable
  /// - You're in a controlled context like a repository that will catch the exception
  ///
  /// **DO NOT** use in UI/presentation layer code where crashes would impact users.
  ///
  /// Prefer using [fold], [dataOrNull], or [getOrElse] instead.
  ///
  /// ```dart
  /// // ❌ BAD - Can crash in UI
  /// final user = result.getOrThrow();
  ///
  /// // ✅ GOOD - Handle both cases
  /// result.fold(
  ///   onSuccess: (user) => showUser(user),
  ///   onFailure: (error) => showError(error),
  /// );
  /// ```
  T getOrThrow() {
    return switch (this) {
      Success(:final data) => data,
      Failure(:final error) => throw error,
    };
  }

  /// Returns the data or a default value.
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(:final data) => data,
      Failure() => defaultValue,
    };
  }
}

/// Represents a successful result with data.
@immutable
final class Success<T> extends Result<T> {
  /// Creates a [Success] instance with the given data.
  const new(this.data);

  /// The successful data value.
  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result with an error.
@immutable
final class Failure<T> extends Result<T> {
  /// Creates a [Failure] instance with the given error.
  const new(this.error);

  /// The error that caused the failure.
  final AppException error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Base exception class for all app exceptions.
/// Extend this for specific error types.
sealed class AppException implements Exception {
  const new({required this.message, this.code, this.stackTrace});

  /// Human-readable error message.
  final String message;

  /// Optional error code for categorization.
  final String? code;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network-related exceptions.
final class NetworkException extends AppException {
  /// Creates a [NetworkException] instance.
  const new({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });

  /// Common factory constructors for typical network errors.
  factory noConnection() => const NetworkException(
    message: 'No internet connection',
    code: 'NO_CONNECTION',
  );

  /// Timeout error
  factory timeout() =>
      const NetworkException(message: 'Request timed out', code: 'TIMEOUT');

  /// Server error (5xx)
  factory serverError([int? statusCode]) => NetworkException(
    message: 'Server error occurred',
    code: 'SERVER_ERROR',
    statusCode: statusCode,
  );

  /// Unauthorized (401)
  factory unauthorized() => const NetworkException(
    message: 'Unauthorized access',
    code: 'UNAUTHORIZED',
    statusCode: 401,
  );

  /// Forbidden (403)
  final int? statusCode;
}

/// Authentication-related exceptions.
final class AuthException extends AppException {
  /// Creates an [AuthException] instance.
  const new({required super.message, super.code, super.stackTrace});

  /// Common factory constructors for typical auth errors.
  factory invalidCredentials() => const AuthException(
    message: 'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );

  /// Session expired
  factory sessionExpired() => const AuthException(
    message: 'Session expired. Please login again',
    code: 'SESSION_EXPIRED',
  );

  /// No active session
  factory noSession() =>
      const AuthException(message: 'No active session', code: 'NO_SESSION');
}

/// Validation-related exceptions.
final class ValidationException extends AppException {
  /// Creates a [ValidationException] instance.
  const new({required super.message, super.code, super.stackTrace, this.field});

  /// The field that failed validation, if applicable.
  final String? field;
}

/// Cache/Storage-related exceptions.
final class CacheException extends AppException {
  /// Creates a [CacheException] instance.
  const new({required super.message, super.code, super.stackTrace});
}

/// Generic unexpected exception.
final class UnexpectedException extends AppException {
  /// Creates an [UnexpectedException] instance.
  const new({
    required super.message,
    super.code,
    super.stackTrace,
    this.originalError,
  });

  /// The original error object, if available.
  final Object? originalError;
}
