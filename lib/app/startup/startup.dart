/// Startup and app lifecycle management module.
///
/// This module handles:
/// - Startup state machine ([StartupState], [StartupSignals], [StartupStateResolver])
/// - App lifecycle management ([AppLifecycleNotifier], [StartupEvent])
/// - Route mapping ([StartupRouteMapper])
///
/// ## Architecture
///
/// The startup system uses a state machine pattern with event-driven transitions:
///
/// 1. **Events** ([StartupEvent]) - "Why are we re-evaluating?"
///    - [AppLaunched], [UserAuthenticated], [UserLoggedOut], etc.
///
/// 2. **Signals** ([StartupSignals]) - "What's the current state of the world?"
///    - isAuthenticated, hasCompletedOnboarding, isInMaintenance
///
/// 3. **States** ([StartupState]) - "What mode is the app in?"
///    - [MaintenanceState], [OnboardingState], [UnauthenticatedState],
///      [AuthenticatedState], [PublicState]
///
/// 4. **Routes** - "Where should the user go?"
///    - Mapped by [StartupRouteMapper.map]
///
/// ## Usage
///
/// ```dart
/// // Initialize on app launch (from SplashPage)
/// final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
/// await lifecycleNotifier.initialize();
///
/// // Handle user login
/// await lifecycleNotifier.onUserLoggedIn(userId);
///
/// // Handle logout
/// await lifecycleNotifier.onUserLoggedOut();
///
/// // Watch current state
/// final state = ref.watch(currentStartupStateProvider);
/// ```
library;

import 'package:riverpod_go_router_boilerplate/app/app_exports.dart'
    show
        AppLaunched,
        AppLifecycleNotifier,
        AuthenticatedState,
        MaintenanceState,
        OnboardingState,
        PublicState,
        StartupEvent,
        StartupRouteMapper,
        StartupSignals,
        StartupState,
        StartupStateResolver,
        UnauthenticatedState,
        UserAuthenticated,
        UserLoggedOut;
import 'package:riverpod_go_router_boilerplate/app/startup/startup.dart'
    show
        AppLaunched,
        AppLifecycleNotifier,
        AuthenticatedState,
        MaintenanceState,
        OnboardingState,
        PublicState,
        StartupEvent,
        StartupRouteMapper,
        StartupSignals,
        StartupState,
        StartupStateResolver,
        UnauthenticatedState,
        UserAuthenticated,
        UserLoggedOut;

export 'app_lifecycle_notifier.dart';
export 'app_lifecycle_state.dart';
export 'presentation/splash_page.dart';
export 'startup_events.dart';
export 'startup_route_mapper.dart';
export 'startup_signals.dart';
export 'startup_state_machine.dart';
export 'startup_state_resolver.dart';
