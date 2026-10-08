/// Custom hooks for Flutter applications.
///
/// This module provides reusable hooks for common patterns:
///
/// - **Basic hooks**: Debounce, toggle, controllers, previous value
/// - **Async hooks**: Async state management, countdown timer
/// - **Pagination hooks**: Infinite scroll support
/// - **Form hooks**: Lightweight form state (prefer reactive_forms for complex forms)
///
/// ## Usage
///
/// ```dart
/// import 'package:riverpod_go_router_boilerplate/core/hooks/hooks.dart';
///
/// class MyPage extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final (isVisible, toggle) = useToggle(false);
///     final asyncState = useAsyncState<User>();
///     final pagination = usePagination<Product>(fetcher: api.fetch);
///
///     return ...;
///   }
/// }
/// ```
library;

// Async state management and countdown
export 'async_hooks.dart';
// Basic hooks (debounce, toggle, controllers)
export 'basic_hooks.dart';
// Form state management (prefer reactive_forms for complex forms)
export 'form_hooks.dart';
// Pagination and infinite scroll
export 'pagination_hooks.dart';
