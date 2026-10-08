import 'package:intl/intl.dart';

/// DateTime extension methods for common operations.
extension DateTimeExtensions on DateTime {
  /// Format as 'Jan 1, 2024'
  String get formatMedium => DateFormat.yMMMd().format(this);

  /// Format as '1/1/2024'
  String get formatShort => DateFormat.yMd().format(this);

  /// Format as 'January 1, 2024'
  String get formatLong => DateFormat.yMMMMd().format(this);

  /// Format as '10:30 AM'
  String get formatTime => DateFormat.jm().format(this);

  /// Format as 'Jan 1, 2024 10:30 AM'
  String get formatDateTime => DateFormat.yMMMd().add_jm().format(this);

  /// Format as 'Monday, January 1'
  String get formatDayMonth => DateFormat.MMMMEEEEd().format(this);

  /// Format with custom pattern
  String format(String pattern) => DateFormat(pattern).format(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get relative time string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Check if date is in the same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days;
    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }
    return result;
  }
}

/// Nullable DateTime extensions
extension NullableDateTimeExtensions on DateTime? {
  /// Format or return default string if null
  String formatOrDefault(String pattern, {String defaultValue = '-'}) {
    if (this == null) return defaultValue;
    return DateFormat(pattern).format(this!);
  }
}
