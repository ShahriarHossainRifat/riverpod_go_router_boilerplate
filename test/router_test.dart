import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';

void main() {
  group('AppRoute', () {
    test('defines required paths with correct auth requirements', () {
      expect(AppRoute.splash.path, '/splash');
      expect(AppRoute.splash.requiresAuth, false);

      expect(AppRoute.login.path, '/login');
      expect(AppRoute.login.requiresAuth, false);

      expect(AppRoute.home.path, '/');
      expect(AppRoute.home.requiresAuth, true);

      expect(AppRoute.settings.path, '/settings');
      expect(AppRoute.settings.requiresAuth, true);

      expect(AppRoute.maintenance.path, '/maintenance');
      expect(AppRoute.maintenance.requiresAuth, false);

      expect(AppRoute.forceUpdate.path, '/force-update');
      expect(AppRoute.forceUpdate.requiresAuth, false);
    });

    test('matchPath resolves static routes accurately', () {
      expect(AppRoute.matchPath('/splash'), AppRoute.splash);
      expect(AppRoute.matchPath('/login'), AppRoute.login);
      expect(AppRoute.matchPath('/'), AppRoute.home);
      expect(AppRoute.matchPath('/settings'), AppRoute.settings);
      expect(AppRoute.matchPath('/maintenance'), AppRoute.maintenance);
      expect(AppRoute.matchPath('/force-update'), AppRoute.forceUpdate);
      expect(AppRoute.matchPath('/unknown-path'), isNull);
    });

    test('protectedRoutes and publicRoutes correctly categorize routes', () {
      final protectedRoutes = AppRoute.protectedRoutes;
      final publicRoutes = AppRoute.publicRoutes;

      expect(protectedRoutes.every((r) => r.requiresAuth), true);
      expect(publicRoutes.every((r) => !r.requiresAuth), true);
      expect(protectedRoutes.contains(AppRoute.home), true);
      expect(protectedRoutes.contains(AppRoute.settings), true);
      expect(publicRoutes.contains(AppRoute.login), true);
      expect(publicRoutes.contains(AppRoute.splash), true);
    });
  });
}
