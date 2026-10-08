import 'package:flutter/material.dart';

/// Standard spacing values used throughout the app.
abstract class AppSpacing {
  /// Private constructor to prevent instantiation.
  const new _();

  /// Extra-small spacing value.
  static const double xs = 4;

  /// Small spacing value.
  static const double sm = 8;

  /// Medium spacing value.
  static const double md = 16;

  /// Large spacing value.
  static const double lg = 24;

  /// Extra-large spacing value.
  static const double xl = 32;

  /// Extra-extra-large spacing value.
  static const double xxl = 48;
}

/// A widget that adds horizontal spacing.
class HorizontalSpace extends StatelessWidget {
  /// Creates an extra-small horizontal space.
  const new xs({super.key}) : width = AppSpacing.xs;

  /// Creates a small horizontal space.
  const new sm({super.key}) : width = AppSpacing.sm;

  /// Creates a medium horizontal space.
  const new md({super.key}) : width = AppSpacing.md;

  /// Creates a large horizontal space.
  const new lg({super.key}) : width = AppSpacing.lg;

  /// Creates an extra-large horizontal space.
  const new xl({super.key}) : width = AppSpacing.xl;

  /// Creates an extra-extra-large horizontal space.
  const new xxl({super.key}) : width = AppSpacing.xxl;

  /// Creates a custom horizontal space.
  const new custom(this.width, {super.key});

  /// Width of the horizontal space.
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

/// A widget that adds vertical spacing.
class VerticalSpace extends StatelessWidget {
  /// Creates an extra-small vertical space.
  const new xs({super.key}) : height = AppSpacing.xs;

  /// Creates a small vertical space.
  const new sm({super.key}) : height = AppSpacing.sm;

  /// Creates a medium vertical space.
  const new md({super.key}) : height = AppSpacing.md;

  /// Creates a large vertical space.
  const new lg({super.key}) : height = AppSpacing.lg;

  /// Creates an extra-large vertical space.
  const new xl({super.key}) : height = AppSpacing.xl;

  /// Creates an extra-extra-large vertical space.
  const new xxl({super.key}) : height = AppSpacing.xxl;

  /// Creates a custom vertical space.
  const new custom(this.height, {super.key});

  /// Height of the vertical space.
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// A padding wrapper with configurable horizontal and vertical spacing.
class ResponsivePadding extends StatelessWidget {
  /// Creates a [ResponsivePadding] widget.
  const new({
    required this.child,
    super.key,
    this.horizontal = AppSpacing.md,
    this.vertical = AppSpacing.md,
  });

  /// Widget to apply padding to.
  final Widget child;

  /// Horizontal padding value.
  final double horizontal;

  /// Vertical padding value.
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }
}

/// A centered container with a maximum width constraint.
class ContentContainer extends StatelessWidget {
  /// Creates a [ContentContainer].
  const new({
    required this.child,
    super.key,
    this.maxWidth = 600,
    this.padding = const .symmetric(horizontal: AppSpacing.md),
  });

  /// Content widget.
  final Widget child;

  /// Maximum width constraint.
  final double maxWidth;

  /// Padding applied inside the container.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
