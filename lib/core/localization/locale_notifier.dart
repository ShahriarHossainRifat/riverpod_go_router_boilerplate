import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:riverpod_go_router_boilerplate/core/storage/shared_preferences_provider.dart';

part 'locale_notifier.g.dart';

/// Storage key for the saved locale.
const _localeKey = 'app_locale';

/// Supported locales in the app.
/// Add new locales here as you add new ARB files.
const supportedLocales = [
  Locale('en'), // English (default)
  Locale('bn'), // Bangla (Bengali)
  // Add more locales as needed:
  // Locale('es'), // Spanish
  // Locale('fr'), // French
  // Locale('de'), // German
  // Locale('zh'), // Chinese
  // Locale('ar'), // Arabic
  // Locale('ja'), // Japanese
  // Locale('hi'), // Hindi
];

/// Provider for managing the app's locale.
///
/// Persists the user's language preference to SharedPreferences.
/// Falls back to the device locale if supported, otherwise defaults to English.
///
/// Usage:
/// ```dart
/// // Get current locale
/// final locale = ref.watch(localeNotifierProvider);
///
/// // Change locale
/// ref.read(localeNotifierProvider.notifier).setLocale(const Locale('es'));
///
/// // Reset to system locale
/// ref.read(localeNotifierProvider.notifier).resetToSystemLocale();
/// ```
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  late SharedPreferences _prefs;

  @override
  Locale? build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadSavedLocale();
  }

  /// Load the saved locale from preferences.
  /// Returns null to use system locale if no preference is saved.
  Locale? _loadSavedLocale() {
    final savedLocaleCode = _prefs.getString(_localeKey);
    if (savedLocaleCode == null) return null;

    final locale = Locale(savedLocaleCode);
    if (supportedLocales.contains(locale)) {
      return locale;
    }
    return null;
  }

  /// Set the app's locale and persist the preference.
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError('Locale $locale is not supported');
    }

    await _prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }

  /// Reset to system locale (removes saved preference).
  Future<void> resetToSystemLocale() async {
    await _prefs.remove(_localeKey);
    state = null;
  }

  /// Check if a locale is supported.
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  /// Get the display name for a locale.
  /// Override this method to provide localized language names.
  String getLocaleName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => 'English',
      'bn' => 'বাংলা',
      'es' => 'Español',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'zh' => '中文',
      'ar' => 'العربية',
      'ja' => '日本語',
      'hi' => 'हिन्दी',
      _ => locale.languageCode.toUpperCase(),
    };
  }
}

/// Alias for the locale notifier provider for backward compatibility.
// ignore: non_constant_identifier_names
LocaleNotifierProvider get localeNotifierProvider => localeProvider;
