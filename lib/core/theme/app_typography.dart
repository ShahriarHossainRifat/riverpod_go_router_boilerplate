import 'package:flutter/material.dart';

/// Centralized application typography definitions.
///
/// Based on the Material 3 typography scale.
abstract class AppTypography {
  /// Private constructor to prevent instantiation.
  const new _();

  /// Default font family used across the app.
  static const String fontFamily = 'Roboto';

  /// Large display text style.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: .w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Medium display text style.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: .w400,
    letterSpacing: 0,
    height: 1.16,
  );

  /// Small display text style.
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: .w400,
    letterSpacing: 0,
    height: 1.22,
  );

  /// Large headline text style.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: .w400,
    letterSpacing: 0,
    height: 1.25,
  );

  /// Medium headline text style.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: .w400,
    letterSpacing: 0,
    height: 1.29,
  );

  /// Small headline text style.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: .w400,
    letterSpacing: 0,
    height: 1.33,
  );

  /// Large title text style.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: .w500,
    letterSpacing: 0,
    height: 1.27,
  );

  /// Medium title text style.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: .w500,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Small title text style.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: .w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Large body text style.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: .w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Medium body text style.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: .w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Small body text style.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: .w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Large label text style.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: .w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Medium label text style.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: .w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Small label text style.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: .w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  /// Builds a [TextTheme] using the defined typography styles.
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
