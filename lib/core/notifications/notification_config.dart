import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Configuration for a local notification.
@immutable
class LocalNotificationConfig {
  /// Creates a [LocalNotificationConfig] instance.
  const new({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.channelId = 'default_channel',
    this.icon,
    this.largeIcon,
    this.importance = Importance.defaultImportance,
    this.priority = Priority.defaultPriority,
    this.playSound = true,
    this.enableVibration = true,
    this.category,
    this.groupKey,
  });

  /// Unique identifier for the notification.
  final int id;

  /// Notification title.
  final String title;

  /// Notification body text.
  final String body;

  /// Optional payload data (e.g., for deep linking).
  final String? payload;

  /// Android notification channel ID.
  final String channelId;

  /// Small icon name (Android only, without extension).
  final String? icon;

  /// Large icon path or asset (Android only).
  final String? largeIcon;

  /// Notification importance level.
  final Importance importance;

  /// Notification priority.
  final Priority priority;

  /// Whether to play sound.
  final bool playSound;

  /// Whether to vibrate.
  final bool enableVibration;

  /// Notification category for grouping.
  final String? category;

  /// Group key for bundling notifications.
  final String? groupKey;
}

/// Callback type for notification tap events.
typedef NotificationTapCallback = void Function(NotificationResponse response);
