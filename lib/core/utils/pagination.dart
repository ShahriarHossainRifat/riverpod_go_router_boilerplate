import 'package:flutter/foundation.dart' show immutable;

/// A paginated response wrapper for API results.
///
/// Use this to represent paginated data from your API.
/// Works with any list type and provides pagination metadata.
///
/// ## Usage
///
/// ```dart
/// // Parse from API response
/// final response = PaginatedResponse<User>.fromJson(
///   json,
///   (item) => User.fromJson(item as Map<String, dynamic>),
/// );
///
/// // Check pagination state
/// if (response.hasMore) {
///   final nextPage = await fetchUsers(page: response.currentPage + 1);
/// }
/// ```
@immutable
class PaginatedResponse<T> {
  /// Creates a paginated response.
  const new({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.pageSize = 20,
  });

  /// Creates an empty response.
  const new empty()
    : items = const [],
      currentPage = 1,
      totalPages = 0,
      totalItems = 0,
      pageSize = 20;

  /// Creates a response from JSON.
  ///
  /// Expects JSON in one of these formats:
  /// ```json
  /// // Format 1: Standard pagination
  /// {
  ///   "data": [...],
  ///   "meta": {
  ///     "current_page": 1,
  ///     "total_pages": 10,
  ///     "total": 100,
  ///     "per_page": 20
  ///   }
  /// }
  ///
  /// // Format 2: Flat pagination
  /// {
  ///   "items": [...],
  ///   "page": 1,
  ///   "total_pages": 10,
  ///   "total_items": 100
  /// }
  /// ```
  factory fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    // Try to find the items array
    final itemsJson =
        json['data'] as List? ?? json['items'] as List? ?? json['results'];

    if (itemsJson == null) {
      throw const FormatException(
        'Could not find items array in response. '
        'Expected "data", "items", or "results" key.',
      );
    }

    final items = (itemsJson as List).map(fromJsonT).toList();

    // Try to extract pagination metadata
    final meta = json['meta'] as Map<String, dynamic>? ?? json;

    return PaginatedResponse<T>(
      items: items,
      currentPage: (meta['current_page'] ?? meta['page'] ?? 1) as int,
      totalPages: (meta['total_pages'] ?? meta['last_page'] ?? 1) as int,
      totalItems: (meta['total'] ?? meta['total_items'] ?? items.length) as int,
      pageSize: (meta['per_page'] ?? meta['page_size'] ?? 20) as int,
    );
  }

  /// The list of items for the current page.
  final List<T> items;

  /// The current page number (1-indexed).
  final int currentPage;

  /// The total number of pages.
  final int totalPages;

  /// The total number of items across all pages.
  final int totalItems;

  /// The number of items per page.
  final int pageSize;

  /// Whether there are more pages to load.
  bool get hasMore => currentPage < totalPages;

  /// Whether this is the first page.
  bool get isFirstPage => currentPage == 1;

  /// Whether this is the last page.
  bool get isLastPage => currentPage >= totalPages;

  /// Whether the response is empty.
  bool get isEmpty => items.isEmpty;

  /// Whether the response has items.
  bool get isNotEmpty => items.isNotEmpty;

  /// The next page number, or null if on last page.
  int? get nextPage => hasMore ? currentPage + 1 : null;

  /// The previous page number, or null if on first page.
  int? get previousPage => currentPage > 1 ? currentPage - 1 : null;

  /// Create a copy with different items.
  PaginatedResponse<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
  }) {
    return PaginatedResponse<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  /// Map items to a different type.
  PaginatedResponse<R> map<R>(R Function(T item) transform) {
    return PaginatedResponse<R>(
      items: items.map(transform).toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      pageSize: pageSize,
    );
  }

  /// Merge with another page (for infinite scroll).
  ///
  /// Combines items from both pages and updates pagination metadata.
  /// Useful for building infinite scroll lists.
  PaginatedResponse<T> merge(PaginatedResponse<T> other) {
    return PaginatedResponse<T>(
      items: [...items, ...other.items],
      currentPage: other.currentPage,
      totalPages: other.totalPages,
      totalItems: other.totalItems,
      pageSize: other.pageSize,
    );
  }

  @override
  String toString() {
    return 'PaginatedResponse('
        'items: ${items.length}, '
        'page: $currentPage/$totalPages, '
        'total: $totalItems)';
  }
}

/// State for managing infinite scroll pagination.
///
/// Use with a Riverpod notifier to manage paginated list state.
///
/// ## Example
///
/// ```dart
/// @riverpod
/// class UserList extends _$UserList {
///   @override
///   Future<PaginationState<User>> build() async {
///     return _fetchPage(1);
///   }
///
///   Future<void> loadMore() async {
///     final currentState = state.valueOrNull;
///     if (currentState == null || !currentState.hasMore || currentState.isLoading) {
///       return;
///     }
///
///     state = AsyncData(currentState.copyWith(isLoading: true));
///
///     final nextPage = await _fetchPage(currentState.currentPage + 1);
///     state = AsyncData(currentState.merge(nextPage));
///   }
/// }
/// ```
@immutable
class PaginationState<T> {
  /// Creates a pagination state.
  const new({
    required this.items,
    required this.currentPage,
    required this.hasMore,
    this.isLoading = false,
    this.error,
  });

  /// Creates an initial empty state.
  const new initial()
    : items = const [],
      currentPage = 0,
      hasMore = true,
      isLoading = false,
      error = null;

  /// Creates a state from a paginated response.
  factory fromResponse(PaginatedResponse<T> response) {
    return PaginationState<T>(
      items: response.items,
      currentPage: response.currentPage,
      hasMore: response.hasMore,
    );
  }

  /// All loaded items across all pages.
  final List<T> items;

  /// The last loaded page number.
  final int currentPage;

  /// Whether there are more pages to load.
  final bool hasMore;

  /// Whether a page is currently being loaded.
  final bool isLoading;

  /// Error from the last load attempt, if any.
  final Object? error;

  /// Whether the list is empty and no more pages.
  bool get isEmpty => items.isEmpty && !hasMore;

  /// Whether this is the initial load.
  bool get isInitialLoad => currentPage == 0 && isLoading;

  /// Whether we can load more (has more and not currently loading).
  bool get canLoadMore => hasMore && !isLoading;

  /// Create a copy with updated fields.
  PaginationState<T> copyWith({
    List<T>? items,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    Object? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Merge with a new page response.
  PaginationState<T> merge(PaginatedResponse<T> response) {
    return PaginationState<T>(
      items: [...items, ...response.items],
      currentPage: response.currentPage,
      hasMore: response.hasMore,
    );
  }

  /// Set loading state.
  PaginationState<T> startLoading() => copyWith(isLoading: true, error: null);

  /// Set error state.
  PaginationState<T> setError(Object error) =>
      copyWith(isLoading: false, error: error);
}
