/// Events that can trigger startup re-evaluation.
///
/// These represent "why we need to reconsider the current state"
/// as opposed to "what state we're in".
sealed class StartupEvent {
  const new();
}

/// App just launched, need initial evaluation
final class AppLaunched extends StartupEvent {
  /// Creates an [AppLaunched] event.
  const new();

  @override
  String toString() => 'AppLaunched()';
}

/// Session was restored from storage
final class SessionRestored extends StartupEvent {
  /// Creates a [SessionRestored] event.
  const new({required this.userId});

  /// The ID of the restored user session.
  final String userId;

  @override
  String toString() => 'SessionRestored(userId: $userId)';
}

/// User successfully authenticated
final class UserAuthenticated extends StartupEvent {
  /// Creates a [UserAuthenticated] event.
  const new({required this.userId});

  /// The ID of the authenticated user.
  final String userId;

  @override
  String toString() => 'UserAuthenticated(userId: $userId)';
}

/// User logged out intentionally
final class UserLoggedOut extends StartupEvent {
  /// Creates a [UserLoggedOut] event.
  const new();

  @override
  String toString() => 'UserLoggedOut()';
}

/// Session expired (token invalid, etc.)
final class SessionExpiredEvent extends StartupEvent {
  /// Creates a [SessionExpiredEvent].
  const new({this.reason});

  /// Optional reason for session expiration.
  final String? reason;

  @override
  String toString() => 'SessionExpiredEvent(reason: $reason)';
}

/// Onboarding was completed
final class OnboardingCompleted extends StartupEvent {
  /// Creates an [OnboardingCompleted] event.
  const new();

  @override
  String toString() => 'OnboardingCompleted()';
}

/// Maintenance mode was enabled
final class MaintenanceEnabled extends StartupEvent {
  /// Creates a [MaintenanceEnabled] event.
  const new({this.message});

  /// Optional maintenance message to display.
  final String? message;

  @override
  String toString() => 'MaintenanceEnabled(message: $message)';
}

/// Maintenance mode was disabled
final class MaintenanceDisabled extends StartupEvent {
  /// Creates a [MaintenanceDisabled] event.
  const new();

  @override
  String toString() => 'MaintenanceDisabled()';
}

/// Remote config was updated
final class RemoteConfigUpdated extends StartupEvent {
  /// Creates a [RemoteConfigUpdated] event.
  const new();

  @override
  String toString() => 'RemoteConfigUpdated()';
}

/// Deep link received that requires navigation
final class DeepLinkReceived extends StartupEvent {
  /// Creates a [DeepLinkReceived] event.
  const new({required this.path});

  /// The deep link path that was received.
  final String path;

  @override
  String toString() => 'DeepLinkReceived(path: $path)';
}
