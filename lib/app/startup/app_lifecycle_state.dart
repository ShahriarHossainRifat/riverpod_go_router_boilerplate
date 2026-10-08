import 'package:riverpod_go_router_boilerplate/app/startup/startup_events.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';

/// Represents the lifecycle state of the application during startup.
///
/// This class holds the current `StartupState`, the last event that caused
/// a transition, an optional previous state for history/transition checks,
/// and a flag indicating whether initial startup work has completed.
///
/// It is intentionally immutable; use [copyWith] to create modified copies.
class AppLifecycleState {
  /// Creates an [AppLifecycleState].
  ///
  /// [currentState] is the active startup state (for example, `PublicState` or
  /// `AuthenticatedState`). [lastEvent] is the most recent event processed by
  /// the lifecycle state machine. [isInitialized] indicates whether the
  /// lifecycle has completed its initial evaluation. [previousState] is
  /// optional and contains the prior state when available.
  const new({
    required this.currentState,
    required this.lastEvent,
    required this.isInitialized,
    this.previousState,
  });

  /// Creates the initial (default) lifecycle state used at app startup.
  ///
  /// By default the app is in `PublicState`, no event has been processed,
  /// there is no previous state, and `isInitialized` is false.
  const new initial()
    : currentState = const PublicState(),
      lastEvent = null,
      previousState = null,
      isInitialized = false;

  /// The currently active startup state.
  final StartupState currentState;

  /// The last event that was processed by the lifecycle state machine.
  ///
  /// This may be `null` if no events have been processed yet.
  final StartupEvent? lastEvent;

  /// The previous startup state, if available.
  ///
  /// Useful for detecting transitions and handling one-time side-effects
  /// when the state changes.
  final StartupState? previousState;

  /// Whether the lifecycle has completed initial initialization.
  ///
  /// Initialization includes running any startup checks (remote config,
  /// maintenance flags, session restoration) required before determining
  /// the final startup state to display.
  final bool isInitialized;

  static const Object _sentinel = Object();

  /// Returns a copy of this state with the provided fields replaced.
  ///
  /// Use this to update a single field while keeping other values intact.
  AppLifecycleState copyWith({
    StartupState? currentState,
    Object? lastEvent = _sentinel,
    Object? previousState = _sentinel,
    bool? isInitialized,
  }) {
    return AppLifecycleState(
      currentState: currentState ?? this.currentState,
      lastEvent: identical(lastEvent, _sentinel)
          ? this.lastEvent
          : lastEvent as StartupEvent?,
      previousState: identical(previousState, _sentinel)
          ? this.previousState
          : previousState as StartupState?,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  /// Returns true when the lifecycle transitioned _from_ [T] to a different
  /// state type.
  ///
  /// Example: `transitionedFrom<AuthenticatedState>()` returns true when the
  /// previous state was `AuthenticatedState` and the current state is not.
  bool transitionedFrom<T extends StartupState>() {
    return previousState is T && currentState is! T;
  }

  @override
  String toString() =>
      'AppLifecycleState(current: $currentState, previous: $previousState, '
      'event: $lastEvent, initialized: $isInitialized)';
}
