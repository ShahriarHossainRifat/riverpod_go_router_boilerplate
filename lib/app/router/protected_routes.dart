import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/presentation/pages/placeholder_page.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/pages/home_page.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/pages/settings_page.dart';

/// Routes that require authentication.
final protectedRoutes = [
  GoRoute(
    path: AppRoute.home.path,
    name: AppRoute.home.name,
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: AppRoute.profile.path,
    name: AppRoute.profile.name,
    builder: (context, state) => const PlaceholderPage(title: 'Profile'),
  ),
  GoRoute(
    path: AppRoute.settings.path,
    name: AppRoute.settings.name,
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    path: AppRoute.onboarding.path,
    name: AppRoute.onboarding.name,
    builder: (context, state) => const OnboardingPage(),
  ),
];
