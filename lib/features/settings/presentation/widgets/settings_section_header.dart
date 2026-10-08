import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Section header for settings groups.
class SettingsSectionHeader extends StatelessWidget {
  /// Creates a [SettingsSectionHeader] instance.
  const new({required this.title, super.key});

  /// The title of the section.
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ResponsivePadding(
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
