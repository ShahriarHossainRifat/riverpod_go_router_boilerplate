import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/presentation/splash_page.dart';

/// The splash route shown during app initialization.
final splashRoute = GoRoute(
  path: AppRoute.splash.path,
  name: AppRoute.splash.name,
  builder: (context, state) => const SplashPage(),
);
