// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_counter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(BadgeCount)
final badgeCountProvider = BadgeCountProvider._();

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
final class BadgeCountProvider extends $AsyncNotifierProvider<BadgeCount, int> {
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
  BadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgeCountHash();

  @$internal
  @override
  BadgeCount create() => BadgeCount();
}

String _$badgeCountHash() => r'baaedd29a4e2c0db30802d6024943e1dc490c3fc';

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

abstract class _$BadgeCount extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
