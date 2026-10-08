import 'package:flutter/material.dart';

/// Centralized application color palette.
///
/// Defines all brand, semantic, and theme-related colors used
/// throughout the app.
abstract class AppColors {
  /// Private constructor to prevent instantiation.
  const new _();

  /// Primary brand color.
  static const Color primary = Color(0xFF6750A4);

  /// Color used on top of [primary].
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Container color for primary elements.
  static const Color primaryContainer = Color(0xFFEADDFF);

  /// Color used on top of [primaryContainer].
  static const Color onPrimaryContainer = Color(0xFF21005D);

  /// Secondary brand color.
  static const Color secondary = Color(0xFF625B71);

  /// Color used on top of [secondary].
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Container color for secondary elements.
  static const Color secondaryContainer = Color(0xFFE8DEF8);

  /// Color used on top of [secondaryContainer].
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  /// Tertiary brand color.
  static const Color tertiary = Color(0xFF7D5260);

  /// Color used on top of [tertiary].
  static const Color onTertiary = Color(0xFFFFFFFF);

  /// Container color for tertiary elements.
  static const Color tertiaryContainer = Color(0xFFFFD8E4);

  /// Color used on top of [tertiaryContainer].
  static const Color onTertiaryContainer = Color(0xFF31111D);

  /// Error color used for validation and failures.
  static const Color error = Color(0xFFB3261E);

  /// Color used on top of [error].
  static const Color onError = Color(0xFFFFFFFF);

  /// Container color for error states.
  static const Color errorContainer = Color(0xFFF9DEDC);

  /// Color used on top of [errorContainer].
  static const Color onErrorContainer = Color(0xFF410E0B);

  /// Success color used for positive states.
  static const Color success = Color(0xFF4CAF50);

  /// Color used on top of [success].
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// Warning color used for cautionary states.
  static const Color warning = Color(0xFFFF9800);

  /// Color used on top of [warning].
  static const Color onWarning = Color(0xFFFFFFFF);

  /// Light theme background color.
  static const Color background = Color(0xFFFFFBFE);

  /// Color used on top of [background].
  static const Color onBackground = Color(0xFF1C1B1F);

  /// Light theme surface color.
  static const Color surface = Color(0xFFFFFBFE);

  /// Color used on top of [surface].
  static const Color onSurface = Color(0xFF1C1B1F);

  /// Variant surface color for components.
  static const Color surfaceVariant = Color(0xFFE7E0EC);

  /// Color used on top of [surfaceVariant].
  static const Color onSurfaceVariant = Color(0xFF49454F);

  /// Dark theme background color.
  static const Color backgroundDark = Color(0xFF1C1B1F);

  /// Color used on top of [backgroundDark].
  static const Color onBackgroundDark = Color(0xFFE6E1E5);

  /// Dark theme surface color.
  static const Color surfaceDark = Color(0xFF1C1B1F);

  /// Color used on top of [surfaceDark].
  static const Color onSurfaceDark = Color(0xFFE6E1E5);

  /// Outline color for borders and dividers.
  static const Color outline = Color(0xFF79747E);

  /// Variant outline color.
  static const Color outlineVariant = Color(0xFFCAC4D0);

  /// Shadow color used for elevation.
  static const Color shadow = Color(0xFF000000);

  /// Scrim color used for modal barriers.
  static const Color scrim = Color(0xFF000000);

  /// Inverse surface color.
  static const Color inverseSurface = Color(0xFF313033);

  /// Color used on top of [inverseSurface].
  static const Color onInverseSurface = Color(0xFFF4EFF4);

  /// Inverse primary color for dark surfaces.
  static const Color inversePrimary = Color(0xFFD0BCFF);
}
