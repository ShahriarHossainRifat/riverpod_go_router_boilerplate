import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/presentation/force_update_page.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/presentation/maintenance_page.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/pages/login_page.dart';

/// Routes that are accessible without authentication.
final authRoutes = [
  GoRoute(
    path: AppRoute.login.path,
    name: AppRoute.login.name,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoute.maintenance.path,
    name: AppRoute.maintenance.name,
    builder: (context, state) => const MaintenancePage(),
  ),
  GoRoute(
    path: AppRoute.forceUpdate.path,
    name: AppRoute.forceUpdate.name,
    builder: (context, state) => const ForceUpdatePage(),
  ),
];
