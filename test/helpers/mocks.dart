import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_service.dart';
import 'package:riverpod_go_router_boilerplate/core/network/api_client.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/local_notification_service.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STORAGE MOCKS
// ─────────────────────────────────────────────────────────────────────────────

/// Mock for [FlutterSecureStorage].
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage;

// ─────────────────────────────────────────────────────────────────────────────
// NETWORK MOCKS
// ─────────────────────────────────────────────────────────────────────────────

/// Mock for [ApiClient].
class MockApiClient extends Mock implements ApiClient;

// ─────────────────────────────────────────────────────────────────────────────
// SERVICE MOCKS
// ─────────────────────────────────────────────────────────────────────────────

/// Mock for [LocalNotificationService].
class MockLocalNotificationService extends Mock
    implements LocalNotificationService;

/// Mock for [CacheService].
class MockCacheService extends Mock implements CacheService;

// ─────────────────────────────────────────────────────────────────────────────
// REPOSITORY MOCKS
// ─────────────────────────────────────────────────────────────────────────────

/// Mock for [AuthRepository].
class MockAuthRepository extends Mock implements AuthRepository;
