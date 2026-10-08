import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

part 'notification_badge_settings.g.dart';

/// Notifier for managing notification enabled state.
///
/// In a real app, this would be persisted to secure storage or user preferences.
@riverpod
class NotificationsEnabled extends _$NotificationsEnabled {
  @override
  bool build() => true;

  /// Toggle notifications enabled state.
  void toggle() {
    state = !state;
  }

  /// Set notifications enabled state.
  void setEnabled({required bool enabled}) {
    state = enabled;
  }
}

/// Simple widget for toggling notifications.
///
/// Demonstrates:
/// - Using Riverpod Notifier with code generation
/// - Proper widget structure following clean architecture principles
/// - Using context extensions for theme access
class NotificationSettings extends ConsumerWidget {
  /// Creates a [NotificationSettings] instance.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(notificationsEnabledProvider);
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(
            isEnabled ? Icons.notifications_active : Icons.notifications_off,
            color: isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          title: Text(l10n.notificationsEnabled),
          subtitle: Text(
            l10n.notificationsEnabledDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          value: isEnabled,
          onChanged: (value) {
            ref
                .read(notificationsEnabledProvider.notifier)
                .setEnabled(enabled: value);
            final message = value
                ? l10n.notificationsEnabledFeedback
                : l10n.notificationsDisabledFeedback;
            ref.read(feedbackServiceProvider).showInfo(message);
          },
        ),
      ],
    );
  }
}
