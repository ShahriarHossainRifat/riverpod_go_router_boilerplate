import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// A styled text field with consistent app styling.
///
/// Use this for all text inputs to ensure consistent appearance.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const new({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autovalidateMode,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Label text above the field.
  final String? label;

  /// Hint text inside the field.
  final String? hint;

  /// Helper text below the field.
  final String? helper;

  /// Error message below the field.
  final String? error;

  /// Widget displayed before the input.
  final Widget? prefix;

  /// Icon displayed before the input.
  final IconData? prefixIcon;

  /// Widget displayed after the input.
  final Widget? suffix;

  /// Icon displayed after the input.
  final IconData? suffixIcon;

  /// Type of keyboard to display.
  final TextInputType? keyboardType;

  /// Action button on keyboard.
  final TextInputAction? textInputAction;

  /// How to capitalize text.
  final TextCapitalization textCapitalization;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to autofocus on build.
  final bool autofocus;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Called when field is tapped.
  final VoidCallback? onTap;

  /// Auto-validation mode.
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        errorText: error,
        prefix: prefix,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffix: suffix,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}

/// A search text field with built-in styling.
class AppSearchField extends StatelessWidget {
  /// Creates an [AppSearchField].
  const new({
    super.key,
    this.controller,
    this.focusNode,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Controller for the search field.
  final TextEditingController? controller;

  /// Focus node for the search field.
  final FocusNode? focusNode;

  /// Hint text in the field.
  final String hint;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits search.
  final ValueChanged<String>? onSubmitted;

  /// Called when clear button is pressed.
  final VoidCallback? onClear;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus on build.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller != null
            ? ListenableBuilder(
                listenable: controller!,
                builder: (context, _) {
                  if (controller!.text.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller!.clear();
                      onClear?.call();
                    },
                  );
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
