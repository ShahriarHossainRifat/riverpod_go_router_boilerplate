import 'package:flutter/material.dart';

/// Number extension methods for common operations.
extension NumExtensions on num {
  // ─────────────────────────────────────────────────────────────────────────────
  // DURATION SHORTCUTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Creates a Duration in milliseconds.
  Duration get ms => Duration(milliseconds: toInt());

  /// Creates a Duration in seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Creates a Duration in minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Creates a Duration in hours.
  Duration get hours => Duration(hours: toInt());

  /// Creates a Duration in days.
  Duration get days => Duration(days: toInt());

  // ─────────────────────────────────────────────────────────────────────────────
  // FORMATTING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Formats number with thousand separators.
  /// Example: 1234567 -> "1,234,567"
  String get formatted {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// Formats as compact number.
  /// Example: 1500 -> "1.5K", 1500000 -> "1.5M"
  String get compact {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Formats as currency with symbol.
  String currency({String symbol = r'$', int decimals = 2}) {
    return '$symbol${toDouble().toStringAsFixed(decimals)}';
  }

  /// Formats as percentage.
  String percent({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Formats file size in human-readable format.
  /// Example: 1536 -> "1.5 KB", 1048576 -> "1 MB"
  String get fileSize {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${units[unitIndex]}';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MATH HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Clamps value between min and max.
  num clamp(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Returns true if value is between min and max (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Converts to radians.
  double get toRadians => this * 3.14159265359 / 180;

  /// Converts to degrees.
  double get toDegrees => this * 180 / 3.14159265359;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Creates BorderRadius with this value.
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  /// Creates EdgeInsets.all with this value.
  EdgeInsets get padding => EdgeInsets.all(toDouble());

  /// Creates symmetric horizontal EdgeInsets.
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Creates symmetric vertical EdgeInsets.
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Creates SizedBox with this width.
  SizedBox get widthBox => SizedBox(width: toDouble());

  /// Creates SizedBox with this height.
  SizedBox get heightBox => SizedBox(height: toDouble());
}

/// Integer-specific extensions.
extension IntExtensions on int {
  /// Generates a list of integers from 0 to this value (exclusive).
  List<int> get range => List.generate(this, (i) => i);

  /// Pads number with leading zeros.
  String padLeft(int width) => toString().padLeft(width, '0');

  /// Returns ordinal suffix (1st, 2nd, 3rd, etc.).
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    return switch (this % 10) {
      1 => '${this}st',
      2 => '${this}nd',
      3 => '${this}rd',
      _ => '${this}th',
    };
  }

  /// Converts seconds to MM:SS format.
  String get toMinutesSeconds {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.padLeft(2)}:${seconds.padLeft(2)}';
  }

  /// Converts seconds to HH:MM:SS format.
  String get toHoursMinutesSeconds {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final seconds = this % 60;
    return '${hours.padLeft(2)}:${minutes.padLeft(2)}:${seconds.padLeft(2)}';
  }
}

/// Double-specific extensions.
extension DoubleExtensions on double {
  /// Rounds to specified decimal places.
  double roundTo(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Returns a normalized value between 0 and 1.
  double normalize(double min, double max) {
    return (this - min) / (max - min);
  }

  /// Linear interpolation to another value.
  double lerp(double end, double t) {
    return this + (end - this) * t;
  }
}
