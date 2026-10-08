import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_state.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_events.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart';
import 'package:riverpod_go_router_boilerplate/core/config/remote_config_service.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/badge_counter.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/local_notification_service.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/data/onboarding_service.dart';

/// Notifier that manages the app lifecycle and state transitions.
class AppLifecycleNotifier extends Notifier<AppLifecycleState>
    with ChangeNotifier {
  @override
  AppLifecycleState build() => const AppLifecycleState.initial();

  /// Initialize the app lifecycle by processing the launch event.
  Future<void> initialize() async {
    if (state.isInitialized) return;

    // Initialize local notifications service
    try {
      final notificationService = ref.read(localNotificationServiceProvider);
      await notificationService.initialize();
      await notificationService.requestPermissions();
    } catch (e) {
      // Notification service initialization is non-critical
      // Continue even if it fails
    }

    await processEvent(const AppLaunched());
    state = state.copyWith(isInitialized: true);
    notifyListeners();
  }

  /// Process a startup event and potentially transition to a new state.
  Future<void> processEvent(StartupEvent event) async {
    final signals = await _collectSignals(event);
    final newState = StartupStateResolver.resolve(signals);

    if (!_isSameStateType(newState, state.currentState)) {
      _transitionTo(newState, event);
    } else {
      state = state.copyWith(lastEvent: event);
    }
  }

  /// Manually trigger re-evaluation of the current state.
  Future<void> reevaluate() async {
    final signals = await _collectCurrentSignals();
    final newState = StartupStateResolver.resolve(signals);

    if (!_isSameStateType(newState, state.currentState)) {
      _transitionTo(newState, null);
    }
  }

  Future<StartupSignals> _collectSignals(StartupEvent event) async {
    return switch (event) {
      AppLaunched() => _collectCurrentSignals(),
      UserAuthenticated() => StartupSignals(
        isInMaintenance: await _checkMaintenance(),
        hasCompletedOnboarding: _checkOnboarding(),
        isAuthenticated: true,
        isAuthEnabled: AppConfig.authEnabled,
        isOnboardingEnabled: AppConfig.onboardingEnabled,
      ),
      UserLoggedOut() || SessionExpiredEvent() => StartupSignals(
        isInMaintenance: await _checkMaintenance(),
        hasCompletedOnboarding: _checkOnboarding(),
        isAuthenticated: false,
        isAuthEnabled: AppConfig.authEnabled,
        isOnboardingEnabled: AppConfig.onboardingEnabled,
      ),
      OnboardingCompleted() => StartupSignals(
        isInMaintenance: await _checkMaintenance(),
        hasCompletedOnboarding: true,
        isAuthenticated: _checkAuth(),
        isAuthEnabled: AppConfig.authEnabled,
        isOnboardingEnabled: AppConfig.onboardingEnabled,
      ),
      MaintenanceEnabled() => StartupSignals(
        isInMaintenance: true,
        hasCompletedOnboarding: _checkOnboarding(),
        isAuthenticated: _checkAuth(),
        isAuthEnabled: AppConfig.authEnabled,
        isOnboardingEnabled: AppConfig.onboardingEnabled,
      ),
      MaintenanceDisabled() => StartupSignals(
        isInMaintenance: false,
        hasCompletedOnboarding: _checkOnboarding(),
        isAuthenticated: _checkAuth(),
        isAuthEnabled: AppConfig.authEnabled,
        isOnboardingEnabled: AppConfig.onboardingEnabled,
      ),
      _ => _collectCurrentSignals(),
    };
  }

  Future<StartupSignals> _collectCurrentSignals() async {
    return StartupSignals(
      isInMaintenance: await _checkMaintenance(),
      hasCompletedOnboarding: _checkOnboarding(),
      isAuthenticated: _checkAuth(),
      isAuthEnabled: AppConfig.authEnabled,
      isOnboardingEnabled: AppConfig.onboardingEnabled,
    );
  }

  Future<bool> _checkMaintenance() async {
    final remoteConfig = ref.read(remoteConfigServiceProvider);
    return remoteConfig.currentConfig.isMaintenanceMode;
  }

  bool _checkOnboarding() {
    try {
      final onboardingService = ref.read(onboardingServiceProvider);
      return onboardingService.isCompleted;
    } catch (_) {
      return true; // Default to completed if service not available
    }
  }

  bool _checkAuth() {
    final sessionState = ref.read(sessionStateProvider);
    return sessionState.isAuthenticated;
  }

  void _transitionTo(StartupState newState, StartupEvent? event) {
    state = AppLifecycleState(
      currentState: newState,
      lastEvent: event,
      previousState: state.currentState,
      isInitialized: state.isInitialized,
    );
    notifyListeners();
  }

  /// Type-safe comparison using sealed class pattern matching.
  /// Avoids fragile runtimeType checks that break with obfuscation.
  bool _isSameStateType(StartupState a, StartupState b) {
    return switch ((a, b)) {
      (AuthenticatedState(), AuthenticatedState()) => true,
      (UnauthenticatedState(), UnauthenticatedState()) => true,
      (OnboardingState(), OnboardingState()) => true,
      (MaintenanceState(), MaintenanceState()) => true,
      (ForceUpdateState(), ForceUpdateState()) => true,
      (PublicState(), PublicState()) => true,
      _ => false,
    };
  }

  // --- Convenience methods ---
  /// Called when a user successfully logs in.
  Future<void> onUserLoggedIn(String userId) async =>
      processEvent(UserAuthenticated(userId: userId));

  /// Called when a user logs out.
  Future<void> onUserLoggedOut() async => processEvent(const UserLoggedOut());

  /// Called when a user session expires.
  Future<void> onSessionExpired({String? reason}) async =>
      processEvent(SessionExpiredEvent(reason: reason));

  /// Called when onboarding is completed.
  Future<void> onOnboardingCompleted() async =>
      processEvent(const OnboardingCompleted());

  /// Called when maintenance mode is enabled or disabled.
  Future<void> onMaintenanceModeChanged({required bool isEnabled}) async =>
      processEvent(
        isEnabled ? const MaintenanceEnabled() : const MaintenanceDisabled(),
      );

  /// Handle app lifecycle state changes (foreground/background).
  ///
  /// Called when the app is resumed from background.
  /// Clears the in-app badge count and processes any pending deep links.
  Future<void> onAppResumed() async {
    // Clear in-app badge state when user opens the app
    try {
      await ref.read(badgeCountProvider.notifier).clearBadge();
    } catch (_) {
      // Badge clearing is non-critical
    }

    // Handle pending deep link from cold start (if any)
    try {
      final notificationService = ref.read(localNotificationServiceProvider);
      final pendingLink = notificationService.consumePendingDeepLink();
      if (pendingLink != null) {
        // Navigate to the pending deep link destination
        // Use a slight delay to ensure the router is fully ready
        await Future<void>.delayed(const Duration(milliseconds: 200));
        final router = ref.read(appRouterProvider);
        router.go(pendingLink);
      }
    } catch (_) {
      // Deep link processing is non-critical
    }
  }

  /// Handle app going to background.
  Future<void> onAppPaused() async {
    // You can implement background tasks here if needed
  }
}

/// Provider for the AppLifecycleNotifier.
final appLifecycleNotifierProvider =
    NotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
      AppLifecycleNotifier.new,
    );

/// Listenable for GoRouter refresh.
final appLifecycleListenableProvider = Provider<Listenable>((ref) {
  return ref.watch(appLifecycleNotifierProvider.notifier);
});

/// Current startup state for convenience.
final currentStartupStateProvider = Provider<StartupState>((ref) {
  return ref.watch(appLifecycleNotifierProvider).currentState;
});

/// Whether app lifecycle is initialized.
final isLifecycleInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appLifecycleNotifierProvider).isInitialized;
});
