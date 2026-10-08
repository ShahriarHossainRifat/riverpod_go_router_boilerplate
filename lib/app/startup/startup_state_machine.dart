import 'package:riverpod_go_router_boilerplate/app/app_exports.dart'
    show StartupStateResolver;
import 'package:riverpod_go_router_boilerplate/app/startup/startup.dart'
    show StartupStateResolver;
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart'
    show StartupStateResolver;

/// Represents the valid startup states of the app.
///
/// These states are mutually exclusive and exhaustive.
/// The app can only be in ONE of these states at any given time.
///
/// State Priority (highest to lowest):
/// 1. [MaintenanceState] - App is under maintenance
/// 2. [ForceUpdateState] - App requires mandatory update
/// 3. [OnboardingState] - User needs to complete onboarding
/// 4. [UnauthenticatedState] - User needs to login
/// 5. [AuthenticatedState] - User is logged in
/// 6. [PublicState] - App doesn't require auth
///
/// See [StartupStateResolver] for the logic that determines the current state.
sealed class StartupState {
  const new();
}

/// App is under maintenance – nothing else is accessible.
/// This state always takes priority over all other states.
final class MaintenanceState extends StartupState {
  /// Creates a [MaintenanceState] instance.
  const new({this.message});

  /// Optional maintenance message to display.
  final String? message;

  @override
  String toString() => 'MaintenanceState(message: $message)';
}

/// App version is below minimum required – force update needed.
/// User must update to continue using the app.
final class ForceUpdateState extends StartupState {
  /// Creates a [ForceUpdateState] instance.
  const new({this.currentVersion, this.minimumVersion, this.storeUrl});

  /// Current app version.
  final String? currentVersion;

  /// Minimum required version.
  final String? minimumVersion;

  /// URL to app store for update.
  final String? storeUrl;

  @override
  String toString() =>
      'ForceUpdateState(current: $currentVersion, minimum: $minimumVersion)';
}

/// User must complete onboarding before accessing the app.
/// Takes priority over authentication states.
final class OnboardingState extends StartupState {
  /// Creates an [OnboardingState] instance.
  const new();

  @override
  String toString() => 'OnboardingState';
}

/// User must authenticate before accessing protected features.
final class UnauthenticatedState extends StartupState {
  /// Creates an [UnauthenticatedState] instance.
  const new();

  @override
  String toString() => 'UnauthenticatedState';
}

/// User is authenticated and can access protected features.
final class AuthenticatedState extends StartupState {
  /// Creates an [AuthenticatedState] instance.
  const new();

  @override
  String toString() => 'AuthenticatedState';
}

/// App does not require authentication at all.
/// For apps that are fully public.
final class PublicState extends StartupState {
  /// Creates a [PublicState] instance.
  const new();

  @override
  String toString() => 'PublicState';
}
