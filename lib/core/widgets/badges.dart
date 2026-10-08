import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';

/// A badge widget for displaying counts or status.
class AppBadge extends StatelessWidget {
  /// Creates an [AppBadge].
  const new({
    super.key,
    this.count,
    this.label,
    this.child,
    this.color,
    this.textColor,
    this.showZero = false,
    this.maxCount = 99,
    this.size = AppBadgeSize.medium,
    this.position = AppBadgePosition.topRight,
  });

  /// Count to display.
  final int? count;

  /// Label to display (instead of count).
  final String? label;

  /// Child widget to attach badge to.
  final Widget? child;

  /// Background color of badge.
  final Color? color;

  /// Text color of badge.
  final Color? textColor;

  /// Whether to show badge when count is 0.
  final bool showZero;

  /// Maximum count to display (shows 99+ if exceeded).
  final int maxCount;

  /// Size of the badge.
  final AppBadgeSize size;

  /// Position of badge relative to child.
  final AppBadgePosition position;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final badgeColor = color ?? theme.colorScheme.error;
    final badgeTextColor = textColor ?? theme.colorScheme.onError;

    // Determine badge content
    String? content;
    if (label != null) {
      content = label;
    } else if (count != null) {
      if (count == 0 && !showZero) {
        if (child != null) return child!;
        return const SizedBox.shrink();
      }
      content = count! > maxCount ? '$maxCount+' : '$count';
    }

    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == AppBadgeSize.small ? 4 : 6,
        vertical: size == AppBadgeSize.small ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(
          size == AppBadgeSize.small ? 8 : 10,
        ),
      ),
      constraints: BoxConstraints(
        minWidth: size == AppBadgeSize.small ? 16 : 20,
        minHeight: size == AppBadgeSize.small ? 16 : 20,
      ),
      child: content != null
          ? Text(
              content,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: size == AppBadgeSize.small ? 10 : 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          : null,
    );

    if (child == null) return badge;

    // Position calculation
    final (top, right, bottom, left) = switch (position) {
      AppBadgePosition.topRight => (-4.0, -4.0, null, null),
      AppBadgePosition.topLeft => (-4.0, null, null, -4.0),
      AppBadgePosition.bottomRight => (null, -4.0, -4.0, null),
      AppBadgePosition.bottomLeft => (null, null, -4.0, -4.0),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: badge,
        ),
      ],
    );
  }
}

/// Size variants for [AppBadge].
enum AppBadgeSize {
  /// Small badge.
  small,

  /// Medium badge.
  medium,
}

/// Position variants for [AppBadge].
enum AppBadgePosition {
  /// Top-right corner.
  topRight,

  /// Top-left corner.
  topLeft,

  /// Bottom-right corner.
  bottomRight,

  /// Bottom-left corner.
  bottomLeft,
}
