import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading wrapper for arbitrary content.
///
/// Applies a shimmer effect to the given child widget.
/// Automatically adapts colors based on theme brightness.
class ShimmerLoading extends StatelessWidget {
  /// Creates a [ShimmerLoading] widget.
  const new({
    required this.child,
    super.key,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  /// Widget to apply the shimmer effect to.
  final Widget child;

  /// Base color of the shimmer animation.
  final Color? baseColor;

  /// Highlight color of the shimmer animation.
  final Color? highlightColor;

  /// Whether the shimmer effect is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = context.theme.brightness == .dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor:
          highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      child: child,
    );
  }
}

/// A shimmer loading placeholder representing a single line of text.
class ShimmerLine extends StatelessWidget {
  /// Creates a [ShimmerLine].
  const new({
    super.key,
    this.width,
    this.height = AppConstants.shimmerLineHeight,
    this.borderRadius = AppConstants.borderRadiusSM,
  });

  /// Optional width of the line.
  final double? width;

  /// Height of the line.
  final double height;

  /// Border radius applied to the line.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? .infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(borderRadius),
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder representing a circular avatar.
class ShimmerCircle extends StatelessWidget {
  /// Creates a [ShimmerCircle].
  const new({super.key, this.size = AppConstants.shimmerCircleSize});

  /// Diameter of the circle.
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Colors.white, shape: .circle),
      ),
    );
  }
}

/// A shimmer loading placeholder for rectangular content.
class ShimmerBox extends StatelessWidget {
  /// Creates a [ShimmerBox].
  const new({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppConstants.borderRadiusMD,
  });

  /// Optional width of the box.
  final double? width;

  /// Optional height of the box.
  final double? height;

  /// Border radius applied to the box.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(borderRadius),
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder resembling a list tile.
class ShimmerListTile extends StatelessWidget {
  /// Creates a [ShimmerListTile].
  const new({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  /// Whether to display a leading avatar placeholder.
  final bool hasLeading;

  /// Whether to display a trailing placeholder.
  final bool hasTrailing;

  /// Number of text lines to display.
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      vertical: AppSpacing.sm,
      child: Row(
        children: [
          if (hasLeading) ...[
            const ShimmerCircle(),
            const HorizontalSpace.md(),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const ShimmerLine(
                  width: 120,
                  height: AppConstants.shimmerTitleHeight,
                ),
                if (lines > 1) ...[
                  const VerticalSpace.sm(),
                  const ShimmerLine(height: AppConstants.shimmerSubtitleHeight),
                ],
                if (lines > 2) ...[
                  const VerticalSpace.sm(),
                  ShimmerLine(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: AppConstants.shimmerSubtitleHeight,
                  ),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const HorizontalSpace.md(),
            const ShimmerBox(width: 24, height: 24),
          ],
        ],
      ),
    );
  }
}

/// A shimmer loading placeholder for a card layout.
class ShimmerCard extends StatelessWidget {
  /// Creates a [ShimmerCard].
  const new({super.key, this.width, this.imageHeight = 120});

  /// Optional width of the card.
  final double? width;

  /// Height of the image placeholder.
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: .circular(AppConstants.borderRadiusLarge),
        border: .all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          ShimmerBox(width: .infinity, height: imageHeight, borderRadius: 12),
          ResponsivePadding(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                ShimmerLine(width: width != null ? width! * 0.7 : 150),
                const VerticalSpace.sm(),
                const ShimmerLine(height: 12),
                const VerticalSpace.xs(),
                ShimmerLine(
                  width: width != null ? width! * 0.5 : 100,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A non-scrollable list of shimmer loading placeholders.
class ShimmerList extends StatelessWidget {
  /// Creates a [ShimmerList].
  const new({
    super.key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  /// Number of list items to display.
  final int itemCount;

  /// Whether each item shows a leading placeholder.
  final bool hasLeading;

  /// Whether each item shows a trailing placeholder.
  final bool hasTrailing;

  /// Number of text lines per item.
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) => ShimmerListTile(
        hasLeading: hasLeading,
        hasTrailing: hasTrailing,
        lines: lines,
      ),
    );
  }
}
