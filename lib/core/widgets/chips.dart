import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// A styled chip widget for tags, filters, etc.
class AppChip extends StatelessWidget {
  /// Creates an [AppChip].
  const new({
    required this.label,
    super.key,
    this.icon,
    this.avatar,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.variant = AppChipVariant.filled,
  });

  /// Label text for the chip.
  final String label;

  /// Optional icon before label.
  final IconData? icon;

  /// Optional avatar widget.
  final Widget? avatar;

  /// Whether chip is selected.
  final bool selected;

  /// Called when selection changes.
  final ValueChanged<bool>? onSelected;

  /// Called when delete is pressed.
  final VoidCallback? onDeleted;

  /// Visual variant of the chip.
  final AppChipVariant variant;

  @override
  Widget build(BuildContext context) {
    if (onDeleted != null) {
      return InputChip(
        label: Text(label),
        avatar:
            avatar ??
            (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
        selected: selected,
        onSelected: onSelected,
        onDeleted: onDeleted,
      );
    }

    if (onSelected != null) {
      return switch (variant) {
        AppChipVariant.filled => FilterChip(
          label: Text(label),
          avatar:
              avatar ??
              (icon != null
                  ? Icon(icon, size: AppConstants.chipIconSize)
                  : null),
          selected: selected,
          onSelected: onSelected,
        ),
        AppChipVariant.outlined => FilterChip.elevated(
          label: Text(label),
          avatar:
              avatar ??
              (icon != null
                  ? Icon(icon, size: AppConstants.chipIconSize)
                  : null),
          selected: selected,
          onSelected: onSelected,
        ),
      };
    }

    return Chip(
      label: Text(label),
      avatar:
          avatar ??
          (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
    );
  }
}

/// Visual variants for [AppChip].
enum AppChipVariant {
  /// Filled chip style.
  filled,

  /// Outlined chip style.
  outlined,
}
