import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Placeholder page for routes that haven't been implemented yet.
///
/// Use this as a temporary page during development.
/// Replace with actual feature pages when ready.
///
/// Usage:
/// ```dart
/// GoRoute(
///   path: AppRoute.profile.path,
///   builder: (context, state) => const PlaceholderPage(title: 'Profile'),
/// ),
/// ```
class PlaceholderPage extends StatelessWidget {
  /// Creates a [PlaceholderPage] widget.
  const new({required this.title, super.key});

  /// The title displayed in the app bar and body.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ResponsivePadding(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                _buildConstructionIcon(context),
                const VerticalSpace.lg(),
                _buildTitle(context),
                const VerticalSpace.sm(),
                _buildDescription(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the construction icon container.
  Widget _buildConstructionIcon(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        shape: .circle,
      ),
      child: Icon(
        Icons.construction_rounded,
        size: 64,
        color: colorScheme.secondary,
      ),
    );
  }

  /// Builds the title text.
  Widget _buildTitle(BuildContext context) {
    final textTheme = context.textTheme;

    return Text(
      title,
      style: textTheme.headlineMedium?.copyWith(fontWeight: .bold),
      textAlign: .center,
    );
  }

  /// Builds the description text.
  Widget _buildDescription(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Text(
      'This page is under construction',
      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      textAlign: .center,
    );
  }
}
