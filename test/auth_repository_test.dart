import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/storage_keys.dart';
import 'package:riverpod_go_router_boilerplate/core/network/api_client.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_mock.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_remote.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';

// Mocks
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage;

class MockApiClient extends Mock implements ApiClient;

void main() {
  group('AuthRepositoryMock', () {
    late MockFlutterSecureStorage mockStorage;
    late AuthRepositoryMock repository;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      repository = AuthRepositoryMock(secureStorage: mockStorage);

      // Setup default mock behavior for all storage operations
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockStorage.delete(
          key: any(named: 'key'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockStorage.deleteAll(
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});
    });

    group('login', () {
      test('returns Success with mock user on valid credentials', () async {
        // Act
        final result = await repository.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.dataOrNull, isA<User>());
        expect(result.dataOrNull?.email, 'test@example.com');
      });

      test('returns Failure on empty password', () async {
        // Act
        final result = await repository.login('test@example.com', '');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorOrNull, isA<AuthException>());
      });

      test('returns Failure on error email', () async {
        // Act
        final result = await repository.login('error@test.com', 'password123');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorOrNull, isA<AuthException>());
      });

      test('stores access token on successful login', () async {
        // Act
        await repository.login('test@example.com', 'password123');

        // Assert
        verify(
          () => mockStorage.write(
            key: StorageKeys.accessToken,
            value: any(named: 'value'),
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).called(1);
      });
    });

    group('logout', () {
      test('returns Success and clears tokens', () async {
        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockStorage.delete(
            key: StorageKeys.accessToken,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).called(1);
      });
    });

    group('restoreSession', () {
      test('returns Success with user when valid session exists', () async {
        // Arrange
        when(
          () => mockStorage.read(
            key: StorageKeys.accessToken,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).thenAnswer((_) async => 'valid_token');

        when(
          () => mockStorage.read(
            key: StorageKeys.userId,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).thenAnswer((_) async => 'user_123');

        // Act
        final result = await repository.restoreSession();

        // Assert
        expect(result.isSuccess, true);
        expect(result.dataOrNull, isA<User>());
      });

      test('returns Failure when no access token', () async {
        // Arrange - default read returns null for any key
        when(
          () => mockStorage.read(
            key: any(named: 'key'),
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.restoreSession();

        // Assert
        expect(result.isFailure, true);
        expect(result.errorOrNull, isA<AuthException>());
      });
    });

    group('isAuthenticated', () {
      test('returns true when token exists', () async {
        // Arrange
        when(
          () => mockStorage.read(
            key: StorageKeys.accessToken,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).thenAnswer((_) async => 'valid_token');

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, true);
      });

      test('returns false when no token', () async {
        // Arrange
        when(
          () => mockStorage.read(
            key: StorageKeys.accessToken,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, false);
      });
    });
  });

  group('AuthRepositoryRemote', () {
    late MockFlutterSecureStorage mockStorage;
    late MockApiClient mockApiClient;
    late AuthRepositoryRemote repository;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      mockApiClient = MockApiClient();
      repository = AuthRepositoryRemote(
        secureStorage: mockStorage,
        apiClient: mockApiClient,
      );

      // Setup default mock behavior
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockStorage.delete(
          key: any(named: 'key'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockStorage.deleteAll(
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
          wOptions: any(named: 'wOptions'),
        ),
      ).thenAnswer((_) async {});
    });

    group('login', () {
      test('returns Success when API returns valid response', () async {
        // Arrange
        when(
          () => mockApiClient.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenAnswer(
          (_) async => const Success({
            'user': {
              'id': 'user_123',
              'email': 'test@example.com',
              'name': 'Test User',
            },
            'token': 'token_abc',
            'refresh_token': 'refresh_xyz',
          }),
        );

        // Act
        final result = await repository.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.dataOrNull?.email, 'test@example.com');
      });

      test('returns Failure when API returns error', () async {
        // Arrange
        when(
          () => mockApiClient.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenAnswer((_) async => Failure(AuthException.invalidCredentials()));

        // Act
        final result = await repository.login('test@example.com', 'wrong');

        // Assert
        expect(result.isFailure, true);
      });

      test('stores tokens on successful login', () async {
        // Arrange
        when(
          () => mockApiClient.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenAnswer(
          (_) async => const Success({
            'user': {'id': 'user_123', 'email': 'test@example.com'},
            'token': 'token_abc',
            'refresh_token': 'refresh_xyz',
          }),
        );

        // Act
        await repository.login('test@example.com', 'password123');

        // Assert
        verify(
          () => mockStorage.write(
            key: StorageKeys.accessToken,
            value: 'token_abc',
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).called(1);
        verify(
          () => mockStorage.write(
            key: StorageKeys.refreshToken,
            value: 'refresh_xyz',
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).called(1);
      });
    });

    group('logout', () {
      test('clears storage even when API call fails', () async {
        // Arrange
        when(
          () => mockApiClient.post<void>(
            '/auth/logout',
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            fromJson: any(named: 'fromJson'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockStorage.delete(
            key: StorageKeys.accessToken,
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
            wOptions: any(named: 'wOptions'),
          ),
        ).called(1);
      });
    });
  });
}
