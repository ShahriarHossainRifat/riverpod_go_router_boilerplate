import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/theme/app_colors.dart';
import 'package:riverpod_go_router_boilerplate/core/theme/app_typography.dart';

/// App theme configuration.
///
/// Provides light and dark themes with shared component styles.
/// Uses Material 3 design system with customizable color schemes.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract class AppTheme {
  // ─────────────────────────────────────────────────────────────────────────────
  // SHARED CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Standard border radius for buttons.
  static const double _buttonRadius = 12;

  /// Standard border radius for cards.
  static const double _cardRadius = 16;

  /// Standard border radius for inputs.
  static const double _inputRadius = 12;

  /// Standard border radius for snackbars.
  static const double _snackBarRadius = 8;

  /// Minimum button size (width x height).
  static const Size _buttonMinSize = Size(.infinity, 48);

  /// Standard input padding.
  static const EdgeInsets _inputPadding = .symmetric(
    horizontal: 16,
    vertical: 16,
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // SHARED COMPONENT THEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Common app bar theme for both light and dark modes.
  static const AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 1,
  );

  /// Common filled button style.
  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: _buttonMinSize,
      shape: RoundedRectangleBorder(borderRadius: .circular(_buttonRadius)),
    ),
  );

  /// Common outlined button style.
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: _buttonMinSize,
          shape: RoundedRectangleBorder(borderRadius: .circular(_buttonRadius)),
        ),
      );

  /// Common text button style.
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: _buttonMinSize,
      shape: RoundedRectangleBorder(borderRadius: .circular(_buttonRadius)),
    ),
  );

  /// Common input decoration theme.
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: .circular(_inputRadius)),
        contentPadding: _inputPadding,
      );

  /// Common card theme.
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: .circular(_cardRadius)),
  );

  /// Common snackbar theme.
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: .floating,
    shape: RoundedRectangleBorder(borderRadius: .circular(_snackBarRadius)),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC THEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Light theme.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: .light,
      colorScheme: _lightColorScheme,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  /// Dark theme.
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: .dark,
      colorScheme: _darkColorScheme,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // COLOR SCHEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Light mode color scheme.
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary: AppColors.inversePrimary,
  );

  /// Dark mode color scheme.
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.inversePrimary,
    onPrimary: AppColors.onPrimaryContainer,
    primaryContainer: AppColors.primary,
    onPrimaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondaryContainer,
    onSecondary: AppColors.onSecondaryContainer,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.onSecondary,
    tertiary: AppColors.tertiaryContainer,
    onTertiary: AppColors.onTertiaryContainer,
    tertiaryContainer: AppColors.tertiary,
    onTertiaryContainer: AppColors.onTertiary,
    error: AppColors.errorContainer,
    onError: AppColors.onErrorContainer,
    errorContainer: AppColors.error,
    onErrorContainer: AppColors.onError,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    surfaceContainerHighest: AppColors.onSurfaceVariant,
    onSurfaceVariant: AppColors.surfaceVariant,
    outline: AppColors.outlineVariant,
    outlineVariant: AppColors.outline,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.onSurface,
    inversePrimary: AppColors.primary,
  );
}
