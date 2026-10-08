import 'package:flutter/material.dart';

import 'package:riverpod_go_router_boilerplate/core/hooks/basic_hooks.dart';

/// State for pagination with infinite scroll.
class InfiniteScrollState<T> {
  /// Creates a [InfiniteScrollState] instance.
  const new({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.error,
    required this.currentPage,
    required this.loadMore,
    required this.refresh,
    required this.reset,
  });

  /// All loaded items.
  final List<T> items;

  /// Whether a page is currently being loaded.
  final bool isLoading;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Error if the last load failed.
  final Object? error;

  /// Current page number (1-indexed).
  final int currentPage;

  /// Loads the next page of items.
  final Future<void> Function() loadMore;

  /// Refreshes from the first page.
  final Future<void> Function() refresh;

  /// Resets the pagination state.
  final VoidCallback reset;

  /// Whether the initial load is in progress.
  bool get isInitialLoading => isLoading && items.isEmpty;

  /// Whether more items are being loaded (not initial).
  bool get isLoadingMore => isLoading && items.isNotEmpty;
}

/// Hook for pagination/infinite scroll.
///
/// ## Usage
///
/// ```dart
/// final pagination = usePagination<Product>(
///   fetcher: (page) => api.fetchProducts(page: page),
///   limit: 20,
/// );
///
/// // Load more on scroll threshold
/// if (!pagination.isLoading && pagination.hasMore) {
///   pagination.loadMore();
/// }
/// ```
InfiniteScrollState<T> usePagination<T>({
  required Future<List<T>> Function(int page) fetcher,
  int limit = 20,
  int initialPage = 1,
}) {
  final context = useContext();
  final items = useState<List<T>>([]);
  final isLoading = useState(false);
  final hasMore = useState(true);
  final error = useState<Object?>(null);
  final currentPage = useState(initialPage);

  Future<void> loadMore() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    error.value = null;

    try {
      final newItems = await fetcher(currentPage.value);

      if (context.mounted) {
        items.value = [...items.value, ...newItems];
        hasMore.value = newItems.length >= limit;
        currentPage.value++;
      }
    } catch (e) {
      if (context.mounted) {
        error.value = e;
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }

  Future<void> refresh() async {
    items.value = [];
    hasMore.value = true;
    currentPage.value = initialPage;
    error.value = null;
    await loadMore();
  }

  void reset() {
    items.value = [];
    isLoading.value = false;
    hasMore.value = true;
    error.value = null;
    currentPage.value = initialPage;
  }

  return InfiniteScrollState<T>(
    items: items.value,
    isLoading: isLoading.value,
    hasMore: hasMore.value,
    error: error.value,
    currentPage: currentPage.value,
    loadMore: loadMore,
    refresh: refresh,
    reset: reset,
  );
}
