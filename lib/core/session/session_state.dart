/// Session state representing the current user session status.
///
/// This abstracts auth state from the rest of the app, providing a
/// clean interface for components that need to know session status
/// without coupling to auth implementation details.
sealed class SessionState {
  const new();

  /// Whether the user has an active session
  bool get isAuthenticated => switch (this) {
    SessionActive() => true,
    SessionInactive() || SessionExpired() || SessionLoading() => false,
  };

  /// Whether session is being restored/validated
  bool get isLoading => this is SessionLoading;

  /// Whether session has expired (requires re-auth)
  bool get isExpired => this is SessionExpired;
}

/// Session is being restored or validated
final class SessionLoading extends SessionState {
  /// Creates a [SessionLoading] instance.
  const new();

  @override
  String toString() => 'SessionLoading()';
}

/// User has an active, valid session
final class SessionActive extends SessionState {
  /// Creates a [SessionActive] instance.
  const new({required this.userId, this.expiresAt});

  /// The ID of the authenticated user.
  final String userId;

  /// The optional expiration time of the session.
  final DateTime? expiresAt;

  /// Whether the session is expiring soon (within 5 minutes).
  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    final timeUntilExpiry = expiresAt!.difference(DateTime.now());
    return timeUntilExpiry.inMinutes < 5;
  }

  @override
  String toString() => 'SessionActive(userId: $userId, expiresAt: $expiresAt)';
}

/// No active session (user logged out or never logged in)
final class SessionInactive extends SessionState {
  /// Creates a [SessionInactive] instance.
  const new();

  @override
  String toString() => 'SessionInactive()';
}

/// Session expired and needs re-authentication
final class SessionExpired extends SessionState {
  /// Creates a [SessionExpired] instance.
  const new({this.reason});

  /// The reason why the session expired, if available.
  final String? reason;

  @override
  String toString() => 'SessionExpired(reason: $reason)';
}
