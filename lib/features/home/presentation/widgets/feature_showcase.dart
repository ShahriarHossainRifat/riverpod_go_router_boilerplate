import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/widgets/feedback_demo_buttons.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/widgets/showcase_item.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// A clean showcase widget demonstrating key boilerplate features.
///
/// This widget shows developers how to use:
/// - AppButton with variants (primary, secondary, text)
/// - FeedbackService for snackbars
/// - AppDialogs for confirmations
/// - Context extensions (theme, colorScheme)
/// - Spacing widgets (VerticalSpace, HorizontalSpace)
/// - Animation widgets (FadeIn, SlideIn, StaggeredList)
class FeatureShowcase extends ConsumerWidget {
  /// Creates a [FeatureShowcase] instance.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);

    return FadeIn(
      child: Card(
        child: ResponsivePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with slide animation
              SlideIn(
                direction: .fromLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: theme.colorScheme.primary,
                      size: AppConstants.iconSizeMD,
                    ),
                    const HorizontalSpace.sm(),
                    Text(
                      l10n.featureShowcase,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpace.sm(),
              FadeIn(
                delay: AppConstants.staggerDelay * 2,
                child: Text(
                  l10n.featureShowcaseDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const VerticalSpace.lg(),

              // Staggered showcase items
              StaggeredList(
                children: [
                  // Demo: Feedback Service
                  ShowcaseItem(
                    title: l10n.feedbackDemo,
                    description: l10n.feedbackDemoDescription,
                    child: FeedbackDemoButtons(ref: ref),
                  ),

                  // Demo: Dialog
                  ShowcaseItem(
                    title: l10n.dialogDemo,
                    description: l10n.dialogDemoDescription,
                    child: AppButton(
                      variant: .text,
                      onPressed: () => _showConfirmDialog(context, l10n),
                      icon: Icons.question_answer_outlined,
                      label: l10n.showDialog,
                    ),
                  ),

                  // Demo: Notifications
                  ShowcaseItem(
                    title: l10n.notificationDemo,
                    description: l10n.notificationDemoDescription,
                    child: AppButton(
                      variant: .secondary,
                      onPressed: () => _sendBasicNotification(ref, l10n),
                      icon: Icons.notifications_outlined,
                      label: l10n.basicNotification,
                    ),
                  ),

                  // Demo: Navigation
                  ShowcaseItem(
                    title: l10n.navigationDemo,
                    description: l10n.navigationDemoDescription,
                    child: AppButton(
                      onPressed: () => context.pushRoute(AppRoute.settings),
                      icon: Icons.settings_outlined,
                      label: l10n.goToSettings,
                    ),
                  ),
                  ShowcaseItem(
                    title: 'Crash Button',
                    description: 'Crash Button Description',
                    child: AppButton(
                      variant: .secondary,
                      onPressed: () => context.push('/invalid_route'),
                      label: 'Crash!',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendBasicNotification(
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final notificationService = ref.read(localNotificationServiceProvider);
    await notificationService.show(
      LocalNotificationConfig(
        id: 1,
        title: l10n.notificationTitle,
        body: l10n.notificationBody,
        channelId: 'high_priority_channel',
      ),
    );
  }

  Future<void> _showConfirmDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: l10n.dialogConfirmTitle,
      message: l10n.dialogConfirmMessage,
      confirmText: l10n.dialogConfirmButton,
      cancelText: l10n.cancel,
    );

    if (confirmed == true && context.mounted) {
      context.showSnackBar(l10n.dialogConfirmed);
    }
  }
}
