/// Session management module.
///
/// Provides:
/// - [SessionState] - Sealed class representing session status
/// - [SessionService] - Service for session operations
/// - `sessionStateProvider` - Reactive session state
/// - `isAuthenticatedProvider` - Simple auth check
library;

import 'package:riverpod_go_router_boilerplate/core/session/session_service.dart'
    show SessionService;
import 'package:riverpod_go_router_boilerplate/core/session/session_state.dart'
    show SessionState;

export 'session_service.dart';
export 'session_state.dart';
