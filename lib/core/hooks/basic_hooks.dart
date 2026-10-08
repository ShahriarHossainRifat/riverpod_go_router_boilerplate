import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Re-export flutter_hooks for convenience
export 'package:flutter_hooks/flutter_hooks.dart';

/// Custom hook for one-time mount effect.
///
/// Executes the callback only once when the widget mounts.
/// Useful for screen tracking, initial API calls, etc.
///
/// Usage:
/// ```dart
/// useOnMount(() {
///   ref.read(analyticsServiceProvider).logScreenView(screenName: 'home');
/// });
/// ```
void useOnMount(VoidCallback callback) {
  useEffect(() {
    callback();
    return null;
  }, const []);
}

/// Custom hook for debounced text input.
///
/// Returns a debounced version of the input value that only updates
/// after the specified delay has passed without new input.
///
/// Useful for search fields to avoid making API calls on every keystroke.
String useDebouncedValue(String value, Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () {
      debouncedValue.value = value;
    });

    return timer.cancel;
  }, [value, delay]);

  return debouncedValue.value;
}

/// Generic debounced value hook for any type.
///
/// Similar to [useDebouncedValue] but works with any type, not just strings.
T useDebounced<T>(T value, Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () {
      debouncedValue.value = value;
    });

    return timer.cancel;
  }, [value, delay]);

  return debouncedValue.value;
}

/// Custom hook for toggle state.
///
/// Usage:
/// ```dart
/// final (isVisible, toggle) = useToggle(false);
/// ```
(bool, VoidCallback) useToggle([bool initialValue = false]) {
  final state = useState(initialValue);
  return (state.value, () => state.value = !state.value);
}

/// Custom hook for text editing controller with auto-dispose.
TextEditingController useTextController({String? text}) {
  return useTextEditingController(text: text);
}

/// Custom hook for focus node with auto-dispose.
FocusNode useFocusNode() {
  final focusNode = useMemoized(FocusNode.new);
  useEffect(() => focusNode.dispose, [focusNode]);
  return focusNode;
}

/// Custom hook for scroll controller with auto-dispose.
ScrollController useScrollController() {
  final controller = useMemoized(ScrollController.new);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

/// Custom hook for page controller with auto-dispose.
PageController usePageController({int initialPage = 0}) {
  final controller = useMemoized(
    () => PageController(initialPage: initialPage),
  );
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

/// Custom hook for previous value tracking.
///
/// Usage:
/// ```dart
/// final prevCount = usePrevious(count);
/// ```
T? usePrevious<T>(T value) {
  final ref = useRef<T?>(null);
  useEffect(() {
    ref.value = value;
    return null;
  }, [value]);
  return ref.value;
}
