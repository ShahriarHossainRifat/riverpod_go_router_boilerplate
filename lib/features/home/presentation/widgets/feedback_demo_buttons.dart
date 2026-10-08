import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Feedback demo buttons widget.
///
/// Demonstrates how to use the [FeedbackService] to show different types
/// of snackbar messages (success, error, info).
class FeedbackDemoButtons extends StatelessWidget {
  /// Creates a [FeedbackDemoButtons] instance.
  const new({required this.ref, super.key});

  /// The Riverpod reference for accessing providers.
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppButton(
            variant: .secondary,
            size: .small,
            onPressed: () => ref
                .read(feedbackServiceProvider)
                .showSuccess('Operation completed!'),
            icon: Icons.check_circle_outline,
            label: l10n.success,
          ),
        ),
        const HorizontalSpace.sm(),
        Expanded(
          child: AppButton(
            variant: .secondary,
            size: .small,
            onPressed: () => ref
                .read(feedbackServiceProvider)
                .showError('Something went wrong.'),
            icon: Icons.error_outline,
            label: l10n.error,
          ),
        ),
        const HorizontalSpace.sm(),
        Expanded(
          child: AppButton(
            variant: .secondary,
            size: .small,
            onPressed: () => ref
                .read(feedbackServiceProvider)
                .showInfo('This is informational.'),
            icon: Icons.info_outline,
            label: l10n.info,
          ),
        ),
      ],
    );
  }
}
