import 'package:flutter/material.dart';

import 'package:riverpod_go_router_boilerplate/core/hooks/basic_hooks.dart';

/// State for async operations with loading/error states.
class AsyncState<T> {
  /// Creates an [AsyncState] instance.
  const new({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.execute,
    required this.reset,
  });

  /// Current data value.
  final T? data;

  /// Whether the async operation is in progress.
  final bool isLoading;

  /// Error object if the operation failed.
  final Object? error;

  /// Executes the given async operation and manages state.
  final Future<void> Function(Future<T> Function() operation) execute;

  /// Resets the state to initial values.
  final VoidCallback reset;
}

/// Hook for managing async operations with loading/error states.
///
/// ## Usage
///
/// ```dart
/// final asyncState = useAsyncState<User>();
/// asyncState.execute(() => fetchUser());
/// ```
AsyncState<T> useAsyncState<T>() {
  final data = useState<T?>(null);
  final isLoading = useState(false);
  final error = useState<Object?>(null);

  Future<void> execute(Future<T> Function() operation) async {
    isLoading.value = true;
    error.value = null;
    try {
      data.value = await operation();
    } catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    data.value = null;
    isLoading.value = false;
    error.value = null;
  }

  return AsyncState(
    data: data.value,
    isLoading: isLoading.value,
    error: error.value,
    execute: execute,
    reset: reset,
  );
}

/// State for countdown timer.
class CountdownState {
  /// Creates a [CountdownState] instance.
  const new({
    required this.remaining,
    required this.isRunning,
    required this.start,
    required this.pause,
    required this.reset,
  });

  /// Seconds remaining in the countdown.
  final int remaining;

  /// Whether the countdown is currently running.
  final bool isRunning;

  /// Starts the countdown.
  final VoidCallback start;

  /// Pauses the countdown.
  final VoidCallback pause;

  /// Resets the countdown to the initial value or a new value.
  final void Function([int?]) reset;
}

/// Hook for counting down from a value.
///
/// ## Usage
///
/// ```dart
/// final countdown = useCountdown(60);
/// countdown.start();
/// print(countdown.remaining);
/// ```
CountdownState useCountdown(int initialSeconds) {
  final context = useContext();
  final remaining = useState(initialSeconds);
  final isRunning = useState(false);

  useEffect(() {
    if (!isRunning.value || remaining.value <= 0) {
      if (remaining.value <= 0) isRunning.value = false;
      return null;
    }

    final future = Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted && isRunning.value && remaining.value > 0) {
        remaining.value--;
      }
    });

    return future.ignore;
  }, [isRunning.value, remaining.value]);

  return CountdownState(
    remaining: remaining.value,
    isRunning: isRunning.value,
    start: () => isRunning.value = true,
    pause: () => isRunning.value = false,
    reset: ([newValue]) {
      remaining.value = newValue ?? initialSeconds;
      isRunning.value = false;
    },
  );
}
