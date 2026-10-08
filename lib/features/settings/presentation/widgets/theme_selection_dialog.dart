import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Shows a dialog for selecting the app theme.
void showThemeSelectionDialog(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  final currentMode = ref.read(themeNotifierProvider);

  showDialog<void>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l10n.chooseTheme),
      children: ThemeMode.values.map((mode) {
        final isSelected = mode == currentMode;
        return SimpleDialogOption(
          onPressed: () {
            ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
            Navigator.of(dialogContext).pop();
          },
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? dialogContext.colorScheme.primary : null,
              ),
              const HorizontalSpace.sm(),
              Text(
                _themeModeLabel(mode, l10n),
                style: isSelected
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dialogContext.colorScheme.primary,
                      )
                    : null,
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) => switch (mode) {
  ThemeMode.light => l10n.lightMode,
  ThemeMode.dark => l10n.darkModeOption,
  ThemeMode.system => l10n.systemDefault,
};
