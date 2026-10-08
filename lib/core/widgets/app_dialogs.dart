import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/buttons.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Helper class for showing dialogs with consistent styling.
abstract class AppDialogs {
  /// Shows a confirmation dialog.
  ///
  /// Returns `true` if confirmed, `false` if cancelled, `null` if dismissed.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            variant: AppButtonVariant.text,
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(false),
            label: cancelText,
          ),
          AppButton(
            variant: isDangerous
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(true),
            label: confirmText,
          ),
        ],
      ),
    );
  }

  /// Shows an alert dialog with a single action.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) {
    final theme = context.theme;

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: icon != null
            ? Icon(
                icon,
                size: AppConstants.dialogIconSize,
                color: theme.colorScheme.primary,
              )
            : null,
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(),
            label: buttonText,
          ),
        ],
      ),
    );
  }

  /// Shows an error dialog.
  static Future<void> error(
    BuildContext context, {
    required String message,
    String title = 'Error',
    String buttonText = 'OK',
  }) {
    final theme = context.theme;

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error_outline,
          size: AppConstants.dialogIconSize,
          color: theme.colorScheme.error,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(),
            label: buttonText,
          ),
        ],
      ),
    );
  }

  /// Shows a success dialog.
  static Future<void> success(
    BuildContext context, {
    required String message,
    String title = 'Success',
    String buttonText = 'OK',
  }) {
    final theme = context.theme;

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle_outline,
          size: AppConstants.dialogIconSize,
          color: theme.colorScheme.primary,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(),
            label: buttonText,
          ),
        ],
      ),
    );
  }

  /// Shows an input dialog.
  ///
  /// Returns the entered text or null if cancelled.
  static Future<String?> input(
    BuildContext context, {
    required String title,
    String? message,
    String? initialValue,
    String? hint,
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    int maxLines = 1,
    String? Function(String?)? validator,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message != null) ...[Text(message), const VerticalSpace.md()],
              TextFormField(
                controller: controller,
                maxLines: maxLines,
                validator: validator,
                decoration: InputDecoration(hintText: hint),
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.text,
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(),
            label: cancelText,
          ),
          AppButton(
            isExpanded: false,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            label: confirmText,
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }

  /// Shows a selection dialog.
  ///
  /// Returns the selected option or null if cancelled.
  static Future<T?> select<T>(
    BuildContext context, {
    required String title,
    required List<SelectOption<T>> options,
    T? selectedValue,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: options.map((option) {
          final isSelected = option.value == selectedValue;
          return SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(option.value),
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    color: isSelected
                        ? context.theme.colorScheme.primary
                        : null,
                  ),
                  const HorizontalSpace.md(),
                ],
                Expanded(
                  child: Text(
                    option.label,
                    style: isSelected
                        ? TextStyle(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          )
                        : null,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check, color: context.theme.colorScheme.primary),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Shows a loading dialog.
  ///
  /// Returns a function to dismiss the dialog.
  static VoidCallback loading(BuildContext context, {String? message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const HorizontalSpace.lg(),
              Expanded(child: Text(message ?? 'Please wait...')),
            ],
          ),
        ),
      ),
    );

    return () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    };
  }
}

/// An option for selection dialogs.
class SelectOption<T> {
  /// Creates a [SelectOption].
  const new({
    required this.value,
    required this.label,
    this.icon,
    this.subtitle,
  });

  /// The value of the option.
  final T value;

  /// Display label for the option.
  final String label;

  /// Optional icon for the option.
  final IconData? icon;

  /// Optional subtitle for the option.
  final String? subtitle;
}
