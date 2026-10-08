import 'package:flutter/material.dart';

/// Types of snackbar messages.
enum SnackbarType {
  /// Success message (green).
  success,

  /// Error message (red).
  error,

  /// Warning message (orange).
  warning,

  /// Informational message (blue).
  info,
}

/// Configuration for a snackbar message.
class SnackbarConfig {
  /// Creates a [SnackbarConfig] instance.
  const new({
    required this.message,
    this.type = SnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.action,
    this.actionLabel,
    this.dismissible = true,
  });

  /// The message to display.
  final String message;

  /// The type of snackbar (affects styling).
  final SnackbarType type;

  /// How long to show the snackbar.
  final Duration duration;

  /// Callback when action button is pressed.
  final VoidCallback? action;

  /// Label for the action button.
  final String? actionLabel;

  /// Whether the snackbar can be dismissed by swiping.
  final bool dismissible;
}

/// Configuration for a dialog.
class DialogConfig {
  /// Creates a [DialogConfig] instance.
  const new({
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'OK',
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.isDestructive = false,
  });

  /// Dialog title.
  final String title;

  /// Simple text message (alternative to content).
  final String? message;

  /// Custom content widget (alternative to message).
  final Widget? content;

  /// Label for confirm button.
  final String confirmLabel;

  /// Label for cancel button (null = no cancel button).
  final String? cancelLabel;

  /// Callback when confirm is pressed.
  final VoidCallback? onConfirm;

  /// Callback when cancel is pressed.
  final VoidCallback? onCancel;

  /// Whether tapping outside dismisses the dialog.
  final bool barrierDismissible;

  /// Whether the action is destructive (affects confirm button styling).
  final bool isDestructive;
}
