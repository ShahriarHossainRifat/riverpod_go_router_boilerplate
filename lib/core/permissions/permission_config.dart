import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a permission request.
enum PermissionResult {
  /// Permission was granted.
  granted,

  /// Permission was denied but can be requested again.
  denied,

  /// Permission was permanently denied (must open settings).
  permanentlyDenied,

  /// Permission is restricted by the system (e.g., parental controls).
  restricted,

  /// Permission request is limited (iOS only).
  limited,
}

/// Extension to convert [PermissionStatus] to [PermissionResult].
extension PermissionStatusX on PermissionStatus {
  /// Convert to [PermissionResult].
  PermissionResult toResult() => switch (this) {
    PermissionStatus.granted => PermissionResult.granted,
    PermissionStatus.denied => PermissionResult.denied,
    PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
    PermissionStatus.restricted => PermissionResult.restricted,
    PermissionStatus.limited => PermissionResult.limited,
    PermissionStatus.provisional => PermissionResult.granted,
  };
}

/// Configuration for a permission request dialog.
class PermissionDialogConfig {
  /// Creates a [PermissionDialogConfig] instance.
  const new({
    required this.title,
    required this.message,
    this.icon,
    this.confirmLabel = 'Allow',
    this.cancelLabel = 'Cancel',
    this.settingsLabel = 'Open Settings',
  });

  /// Dialog title.
  final String title;

  /// Explanation message for why the permission is needed.
  final String message;

  /// Optional icon to display.
  final IconData? icon;

  /// Label for the confirm/allow button.
  final String confirmLabel;

  /// Label for the cancel button.
  final String cancelLabel;

  /// Label for the "open settings" button.
  final String settingsLabel;
}

/// Common permission dialog configurations.
abstract class PermissionDialogs {
  /// Camera permission dialog.
  static const camera = PermissionDialogConfig(
    title: 'Camera Permission',
    message: 'We need camera access to take photos.',
    icon: Icons.camera_alt,
  );

  /// Microphone permission dialog.
  static const microphone = PermissionDialogConfig(
    title: 'Microphone Permission',
    message: 'We need microphone access to record audio.',
    icon: Icons.mic,
  );

  /// Location permission dialog.
  static const location = PermissionDialogConfig(
    title: 'Location Permission',
    message: 'We need your location to provide relevant local content.',
    icon: Icons.location_on,
  );

  /// Storage permission dialog.
  static const storage = PermissionDialogConfig(
    title: 'Storage Permission',
    message: 'We need storage access to save files.',
    icon: Icons.folder,
  );

  /// Photos permission dialog.
  static const photos = PermissionDialogConfig(
    title: 'Photos Permission',
    message: 'We need access to your photos to let you choose images.',
    icon: Icons.photo_library,
  );

  /// Notification permission dialog.
  static const notification = PermissionDialogConfig(
    title: 'Notification Permission',
    message: 'Enable notifications to stay updated.',
    icon: Icons.notifications,
  );

  /// Contacts permission dialog.
  static const contacts = PermissionDialogConfig(
    title: 'Contacts Permission',
    message: 'We need access to your contacts.',
    icon: Icons.contacts,
  );

  /// Calendar permission dialog.
  static const calendar = PermissionDialogConfig(
    title: 'Calendar Permission',
    message: 'We need calendar access to manage your events.',
    icon: Icons.calendar_today,
  );
}
