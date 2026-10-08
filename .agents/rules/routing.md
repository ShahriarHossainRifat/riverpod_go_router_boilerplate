# Routing & Navigation Standards

## GoRouter Declarative Routing

The application uses GoRouter with type-safe route definitions and centralized lifecycle guards.

### Route Enum (`AppRoute`)

All routes must be registered in `lib/app/router/app_route.dart`:
```dart
enum AppRoute {
  splash('/splash'),
  login('/login'),
  home('/'),
  settings('/settings'),
  onboarding('/onboarding'),
  maintenance('/maintenance'),
  forceUpdate('/force-update');

  const AppRoute(this.path);
  final String path;
}
```

### Route Navigation

- **Push screen:** `context.push(AppRoute.settings.path)`
- **Replace screen:** `AppRoute.home.go(context)` or `context.go(AppRoute.home.path)`
- **Named navigation:** `context.goNamed(AppRoute.home.name)`

Never use string literals (e.g. `context.go('/home')`).

### Centralized Route Guards

All redirects are evaluated inside `appRouterProvider` in `lib/app/router/app_router.dart`:
1. `_guardLoading`: Holds user on splash screen while initial session check completes.
2. `_guardInitialization`: Ensures startup state machine initialized before proceeding.
3. `_guardMaintenance`: Redirects all requests to `/maintenance` when backend is down.
4. `_guardForceUpdate`: Redirects outdated app versions to `/force-update`.
5. `_guardAuth`:
   - Redirects unauthenticated users from protected routes to `/login`.
   - Redirects authenticated users from `/login` back to `/home`.

Never perform manual route redirects upon successful login in UI code; updating `authProvider` automatically triggers GoRouter's redirect guard.
