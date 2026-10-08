import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// A configurable button with consistent app styling.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const new({
    required this.onPressed,
    required this.label,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
  });

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Text label displayed on the button.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Whether to show a loading indicator instead of content.
  final bool isLoading;

  /// Whether the button expands to full available width.
  final bool isExpanded;

  /// Visual style variant of the button.
  final AppButtonVariant variant;

  /// Size configuration of the button.
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    final Widget child = isLoading
        ? SizedBox(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == .primary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: isExpanded ? .max : .min,
            mainAxisAlignment: .center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize),
                const HorizontalSpace.sm(),
              ],
              Text(label),
            ],
          );

    final button = switch (variant) {
      .primary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
      .secondary => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
      .text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
    };

    return isExpanded ? SizedBox(width: .infinity, child: button) : button;
  }

  double get _iconSize => switch (size) {
    .small => 16,
    .medium => 20,
    .large => 24,
  };

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(_minSize),
      padding: WidgetStatePropertyAll(_padding),
    );
  }

  Size get _minSize => switch (size) {
    .small => const Size(64, 36),
    .medium => const Size(88, 44),
    .large => const Size(112, 52),
  };

  EdgeInsets get _padding => switch (size) {
    .small => const .symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    .medium => const .symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    .large => const .symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  };
}

/// Visual variants for [AppButton].
enum AppButtonVariant {
  /// Primary filled button.
  primary,

  /// Secondary outlined button.
  secondary,

  /// Text-only button.
  text,
}

/// Size options for [AppButton].
enum AppButtonSize {
  /// Small button size.
  small,

  /// Medium button size.
  medium,

  /// Large button size.
  large,
}

/// An icon-only button with consistent styling.
class AppIconButton extends StatelessWidget {
  /// Creates an [AppIconButton].
  const new({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.variant = .standard,
    this.size = 24,
    this.isLoading = false,
  });

  /// Icon displayed inside the button.
  final IconData icon;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional tooltip text.
  final String? tooltip;

  /// Visual style variant of the icon button.
  final AppIconButtonVariant variant;

  /// Icon size.
  final double size;

  /// Whether to show a loading indicator instead of the icon.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      .standard => IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      .filled => IconButton.filled(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      .outlined => IconButton.outlined(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      .filledTonal => IconButton.filledTonal(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
    };
  }

  Widget _buildIcon(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: size * 0.8,
        height: size * 0.8,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Icon(icon);
  }
}

/// Visual variants for [AppIconButton].
enum AppIconButtonVariant {
  /// Standard icon button.
  standard,

  /// Filled icon button.
  filled,

  /// Outlined icon button.
  outlined,

  /// Filled tonal icon button.
  filledTonal,
}
