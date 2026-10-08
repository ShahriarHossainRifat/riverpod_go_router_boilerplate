import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'badge_counter.g.dart';

/// Manages the in-app badge count state.
///
/// This provider tracks the notification badge count for use in the UI
/// (e.g., showing a badge on the inbox icon, bottom navigation, etc.).
///
/// ## Modern Badge Handling Strategy (2025+)
///
/// - **iOS app icon badge**: Managed via APNS payload from server (badge field
///   in push notification). This is the industry-standard approach.
/// - **Android app icon**: Uses notification dots (automatic with Android 8.0+).
///   Numerical badges depend on launcher support.
/// - **In-app UI badges**: Use this provider to show badges on icons, tabs, etc.
///
/// This provider is intentionally kept simple and focused on in-app state.
/// It does NOT sync with the OS app icon badge - that's handled server-side
/// for push notifications, which is the recommended approach.
///
/// ## Example Usage:
/// ```dart
/// // Get current badge count (for displaying in UI)
/// final badgeCount = ref.watch(badgeCountProvider);
///
/// badgeCount.when(
///   data: (count) => count > 0 ? Badge(label: '$count') : null,
///   loading: () => null,
///   error: (_, __) => null,
/// );
///
/// // Increment badge (e.g., when new notification arrives)
/// ref.read(badgeCountProvider.notifier).increment();
///
/// // Clear badge (e.g., when user opens notifications)
/// ref.read(badgeCountProvider.notifier).clearBadge();
/// ```
@riverpod
class BadgeCount extends _$BadgeCount {
  @override
  Future<int> build() async {
    // Initialize with 0 badge count
    return 0;
  }

  /// Increment the badge count by 1.
  Future<void> increment() async {
    final currentCount = state.value ?? 0;
    final newCount = currentCount + 1;
    state = AsyncValue.data(newCount);
    _logBadgeChange(newCount);
  }

  /// Decrement the badge count by 1.
  ///
  /// Will not go below 0.
  Future<void> decrement() async {
    final currentCount = state.value ?? 0;
    final newCount = (currentCount - 1).clamp(0, double.infinity).toInt();
    state = AsyncValue.data(newCount);
    _logBadgeChange(newCount);
  }

  /// Set the badge count to a specific value.
  Future<void> updateCount(int count) async {
    state = AsyncValue.data(count);
    _logBadgeChange(count);
  }

  /// Clear the badge (set count to 0).
  ///
  /// Call this when the user opens the app or reads all notifications.
  Future<void> clearBadge() async {
    state = const AsyncValue.data(0);
    _logBadgeChange(0);
  }

  /// Increment badge in response to a new notification.
  ///
  /// This is a convenience method that increments and returns the new count.
  Future<int> onNewNotification() async {
    await increment();
    return state.value ?? 0;
  }

  /// Add multiple notifications at once.
  ///
  /// Useful if you're processing a batch of notifications.
  Future<void> addNotifications(int count) async {
    final currentCount = state.value ?? 0;
    final newCount = currentCount + count;
    state = AsyncValue.data(newCount);
    _logBadgeChange(newCount);
  }

  /// Reset badge count.
  ///
  /// This is useful for testing or when you want to start fresh.
  Future<void> reset() async {
    state = const AsyncValue.data(0);
  }

  void _logBadgeChange(int count) {
    try {
      final logger = ref.read(loggerProvider);
      logger.d('Badge count updated to: $count');
    } catch (_) {
      // Logger might not be available in tests
    }
  }
}
