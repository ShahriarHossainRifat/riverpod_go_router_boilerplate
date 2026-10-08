import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/auth.dart';

class MockAuthRepository extends Mock implements AuthRepository;

void main() {
  group('SessionService', () {
    late MockAuthRepository mockAuthRepo;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      when(() => mockAuthRepo.restoreSession())
          .thenAnswer((_) async => Failure(AuthException.noSession()));
      when(() => mockAuthRepo.logout())
          .thenAnswer((_) async => const Success(null));

      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepo)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('validates active session correctly', () async {
      final sessionService = container.read(sessionServiceProvider);
      // Initially inactive
      expect(await sessionService.validateSession(), false);
    });

    test(
      'calls all registered logout callbacks on endSession in order',
      () async {
        final sessionService = container.read(sessionServiceProvider);
        final executionOrder = <int>[];

        sessionService
          ..addLogoutCallback((ref) {
            executionOrder.add(1);
          })
          ..addLogoutCallback((ref) {
            executionOrder.add(2);
          });

        await sessionService.endSession();

        expect(executionOrder, [1, 2]);
        verify(() => mockAuthRepo.logout()).called(1);
      },
    );

    test('removes registered logout callback correctly', () async {
      final sessionService = container.read(sessionServiceProvider);
      var called = false;
      void callback(Ref ref) {
        called = true;
      }

      sessionService
        ..addLogoutCallback(callback)
        ..removeLogoutCallback(callback);

      await sessionService.endSession();

      expect(called, false);
      verify(() => mockAuthRepo.logout()).called(1);
    });
  });
}
