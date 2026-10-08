import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// A divider with optional label text.
class AppDivider extends StatelessWidget {
  /// Creates an [AppDivider].
  const new({
    super.key,
    this.label,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  /// Optional label to display in the middle.
  final String? label;

  /// Thickness of the divider.
  final double thickness;

  /// Indent from the leading edge.
  final double indent;

  /// Indent from the trailing edge.
  final double endIndent;

  /// Color of the divider.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final dividerColor = color ?? theme.dividerColor;

    if (label == null) {
      return Divider(
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: dividerColor,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            indent: indent,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            endIndent: endIndent,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}
