import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// A single showcase item with title, description, and demo widget.
///
/// Used to display individual feature demonstrations in a consistent format
/// within the FeatureShowcase widget.
class ShowcaseItem extends StatelessWidget {
  /// Creates a [ShowcaseItem] instance.
  const new({
    required this.title,
    required this.description,
    required this.child,
    super.key,
  });

  /// The title of the showcase item.
  final String title;

  /// The description explaining what this demo shows.
  final String description;

  /// The demo widget to display.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const VerticalSpace.xs(),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const VerticalSpace.sm(),
        child,
      ],
    );
  }
}
