import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';

/// Resolves the current startup state from signals.
///
/// This is a pure function with no side effects.
/// Given the same signals, it will always return the same state.
///
/// Priority order:
/// 1. Maintenance ALWAYS wins (blocks everything)
/// 2. Force update BEFORE anything else (must update to continue)
/// 3. Onboarding BEFORE auth (must be completed first)
/// 4. No-auth apps go to public state
/// 5. Auth required → check authentication
/// 6. Fully authenticated → grant access
///
/// Example:
/// ```dart
/// final state = StartupStateResolver.resolve(signals);
/// final route = StartupRouteMapper.map(state);
/// context.go(route);
/// ```
class StartupStateResolver {
  const new _();

  /// Resolve the startup state from the given signals.
  static StartupState resolve(StartupSignals signals) {
    // 1️⃣ Maintenance ALWAYS wins
    if (signals.isInMaintenance) {
      return MaintenanceState(message: signals.maintenanceMessage);
    }

    // 2️⃣ Force update BEFORE anything else
    if (signals.requiresForceUpdate) {
      return ForceUpdateState(
        currentVersion: signals.currentVersion,
        minimumVersion: signals.minimumVersion,
      );
    }

    // 3️⃣ Onboarding BEFORE auth
    if (signals.isOnboardingEnabled && !signals.hasCompletedOnboarding) {
      return const OnboardingState();
    }

    // 4️⃣ No-auth apps
    if (!signals.isAuthEnabled) {
      return const PublicState();
    }

    // 5️⃣ Auth required
    if (!signals.isAuthenticated) {
      return const UnauthenticatedState();
    }

    // 6️⃣ Fully authenticated
    return const AuthenticatedState();
  }
}
