import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_go_router_boilerplate/app/app.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/mocks.dart';

void main() {
  setUpAll(() async {
    // Initialize environment before tests
    EnvConfig.initialize(environment: Environment.dev);
    // Initialize SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App boots without crashing', (tester) async {
    // Create mock notification service
    final mockNotificationService = MockLocalNotificationService();
    when(mockNotificationService.initialize).thenAnswer((_) async => true);

    // Use runAsync to handle real async operations (like timers in SplashPage)
    await tester.runAsync(() async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            localNotificationServiceProvider.overrideWithValue(
              mockNotificationService,
            ),
          ],
          child: const App(),
        ),
      );

      // Wait for the splash page timer to complete
      await Future<void>.delayed(const Duration(seconds: 1));
      await tester.pump();
    });

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
