/// Duration extension methods for common operations.
extension DurationExtensions on Duration {
  // ─────────────────────────────────────────────────────────────────────────────
  // FORMATTING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Formats duration as HH:MM:SS.
  String get formatted {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats duration as human-readable string.
  /// Example: "2 hours, 30 minutes"
  String get humanReadable {
    final parts = <String>[];

    if (inDays > 0) {
      parts.add('$inDays ${inDays == 1 ? 'day' : 'days'}');
    }
    if (inHours.remainder(24) > 0) {
      final hours = inHours.remainder(24);
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (inMinutes.remainder(60) > 0) {
      final minutes = inMinutes.remainder(60);
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }
    if (inSeconds.remainder(60) > 0 && inMinutes == 0) {
      final seconds = inSeconds.remainder(60);
      parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
    }

    if (parts.isEmpty) return '0 seconds';
    return parts.join(', ');
  }

  /// Formats as compact human-readable string.
  /// Example: "2h 30m"
  String get compact {
    final parts = <String>[];

    if (inDays > 0) parts.add('${inDays}d');
    if (inHours.remainder(24) > 0) parts.add('${inHours.remainder(24)}h');
    if (inMinutes.remainder(60) > 0) parts.add('${inMinutes.remainder(60)}m');
    if (inSeconds.remainder(60) > 0 && inMinutes == 0) {
      parts.add('${inSeconds.remainder(60)}s');
    }

    if (parts.isEmpty) return '0s';
    return parts.join(' ');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // UTILITIES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns a delayed Future.
  Future<void> get delay => Future.delayed(this);

  /// Returns the absolute value of the duration.
  Duration get abs => isNegative ? -this : this;

  /// Multiplies duration by a factor.
  Duration operator *(num factor) {
    return Duration(microseconds: (inMicroseconds * factor).round());
  }

  /// Divides duration by a factor.
  Duration operator /(num divisor) {
    return Duration(microseconds: (inMicroseconds / divisor).round());
  }

  /// Returns true if duration is zero.
  bool get isZero => this == Duration.zero;

  /// Returns true if duration is not zero.
  bool get isNotZero => this != Duration.zero;
}
