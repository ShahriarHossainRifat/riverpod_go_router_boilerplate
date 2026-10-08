import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('creates a successful result with data', () {
        const Result<int> result = Success(42);

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.dataOrNull, equals(42));
        expect(result.errorOrNull, isNull);
      });

      test('getOrElse returns data for success', () {
        const Result<int> result = Success(42);

        expect(result.getOrElse(0), equals(42));
      });

      test('getOrThrow returns data for success', () {
        const Result<int> result = Success(42);

        expect(result.getOrThrow(), equals(42));
      });

      test('map transforms success data', () {
        const Result<int> result = Success(42);
        final mapped = result.map((data) => data * 2);

        expect(mapped.dataOrNull, equals(84));
      });

      test('fold calls onSuccess for success', () {
        const Result<int> result = Success(42);
        final foldResult = result.fold(
          onSuccess: (data) => 'success: $data',
          onFailure: (error) => 'failure: ${error.message}',
        );

        expect(foldResult, equals('success: 42'));
      });
    });

    group('Failure', () {
      test('creates a failed result with error', () {
        const Result<int> result = Failure(
          NetworkException(message: 'error message'),
        );

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.dataOrNull, isNull);
        expect(result.errorOrNull, isNotNull);
      });

      test('getOrElse returns fallback for failure', () {
        const Result<int> result = Failure(NetworkException(message: 'error'));

        expect(result.getOrElse(99), equals(99));
      });

      test('getOrThrow throws for failure', () {
        const Result<int> result = Failure(NetworkException(message: 'error'));

        expect(result.getOrThrow, throwsA(isA<NetworkException>()));
      });

      test('fold calls onFailure for failure', () {
        const Result<int> result = Failure(
          NetworkException(message: 'test error'),
        );
        final foldResult = result.fold(
          onSuccess: (data) => 'success: $data',
          onFailure: (error) => 'failure: ${error.message}',
        );

        expect(foldResult, equals('failure: test error'));
      });
    });

    group('NetworkException', () {
      test('noConnection creates with correct message', () {
        final exception = NetworkException.noConnection();
        expect(exception.message, contains('connection'));
      });

      test('timeout creates with correct message', () {
        final exception = NetworkException.timeout();
        expect(exception.message.toLowerCase(), contains('timed out'));
      });

      test('serverError creates with status code', () {
        final exception = NetworkException.serverError(500);
        expect(exception.statusCode, equals(500));
      });

      test('unauthorized creates with 401 status', () {
        final exception = NetworkException.unauthorized();
        expect(exception.statusCode, equals(401));
      });
    });

    group('AuthException', () {
      test('invalidCredentials creates with message', () {
        final exception = AuthException.invalidCredentials();
        expect(exception.message, isNotEmpty);
      });

      test('sessionExpired creates with session message', () {
        final exception = AuthException.sessionExpired();
        expect(exception.message.toLowerCase(), contains('session'));
      });

      test('noSession creates with no session message', () {
        final exception = AuthException.noSession();
        expect(exception.message.toLowerCase(), contains('session'));
      });
    });

    group('ValidationException', () {
      test('can be created with field', () {
        const exception = ValidationException(
          message: 'Invalid email',
          field: 'email',
        );
        expect(exception.field, equals('email'));
        expect(exception.message, equals('Invalid email'));
      });
    });
  });
}
