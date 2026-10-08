import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/localization/locale_notifier.dart';

/// Theme mode notifier for managing app theme
class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(_themeKey);
    return themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.system;
  }

  /// Set the theme mode and persist the choice
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeKey, mode.index);
  }

  /// Toggle between light, dark, and system themes
  void toggleTheme() {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    setThemeMode(newMode);
  }

  /// Convenience methods to set specific themes
  void setLight() => setThemeMode(.light);

  /// Convenience methods to set specific themes
  void setDark() => setThemeMode(.dark);

  /// Convenience methods to set specific themes
  void setSystem() => setThemeMode(.system);
}

/// Provider for the theme notifier
final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

/// Provider that returns true if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeNotifierProvider);
  if (themeMode == .system) {
    // This will need to be updated based on actual platform brightness
    // In the widget tree, use context.isDarkMode instead
    return false;
  }
  return themeMode == .dark;
});
