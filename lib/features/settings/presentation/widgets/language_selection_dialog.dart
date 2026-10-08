import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Shows a dialog for selecting the app language.
void showLanguageSelectionDialog(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  final currentLocale = ref.read(localeNotifierProvider) ?? const Locale('en');

  showDialog<void>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l10n.chooseLanguage),
      children: [
        _buildLanguageOption(
          dialogContext,
          'en',
          l10n.english,
          currentLocale.languageCode == 'en',
          () {
            ref
                .read(localeNotifierProvider.notifier)
                .setLocale(const Locale('en'));
            Navigator.of(dialogContext).pop();
          },
        ),
        _buildLanguageOption(
          dialogContext,
          'bn',
          l10n.bengali,
          currentLocale.languageCode == 'bn',
          () {
            ref
                .read(localeNotifierProvider.notifier)
                .setLocale(const Locale('bn'));
            Navigator.of(dialogContext).pop();
          },
        ),
      ],
    ),
  );
}

SimpleDialogOption _buildLanguageOption(
  BuildContext context,
  String languageCode,
  String languageName,
  bool isSelected,
  VoidCallback onTap,
) {
  return SimpleDialogOption(
    onPressed: onTap,
    child: Row(
      children: [
        Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: isSelected ? context.colorScheme.primary : null,
        ),
        const HorizontalSpace.sm(),
        Text(
          languageName,
          style: isSelected
              ? TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                )
              : null,
        ),
      ],
    ),
  );
}
