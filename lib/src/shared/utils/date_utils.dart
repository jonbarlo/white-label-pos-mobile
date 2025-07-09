import 'package:intl/intl.dart';

/// Date utility class for consistent date formatting and manipulation
class AppDateUtils {
  static const String _defaultDateFormat = 'yyyy-MM-dd';
  static const String _defaultTimeFormat = 'HH:mm:ss';
  static const String _defaultDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String _displayDateFormat = 'MMM dd, yyyy';
  static const String _displayTimeFormat = 'HH:mm';
  static const String _displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  /// Format date to string
  static String formatDate(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? _defaultDateFormat);
    return formatter.format(date);
  }

  /// Format time to string
  static String formatTime(DateTime time, {String? format}) {
    final formatter = DateFormat(format ?? _defaultTimeFormat);
    return formatter.format(time);
  }

  /// Format date and time to string
  static String formatDateTime(DateTime dateTime, {String? format}) {
    final formatter = DateFormat(format ?? _defaultDateTimeFormat);
    return formatter.format(dateTime);
  }

  /// Format date for display
  static String formatDateForDisplay(DateTime date) {
    return formatDate(date, format: _displayDateFormat);
  }

  /// Format time for display
  static String formatTimeForDisplay(DateTime time) {
    return formatTime(time, format: _displayTimeFormat);
  }

  /// Format date and time for display
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return formatDateTime(dateTime, format: _displayDateTimeFormat);
  }

  /// Parse string to date
  static DateTime? parseDate(String dateString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? _defaultDateFormat);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse string to time
  static DateTime? parseTime(String timeString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? _defaultTimeFormat);
      return formatter.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Parse string to date and time
  static DateTime? parseDateTime(String dateTimeString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? _defaultDateTimeFormat);
      return formatter.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago", "3 days ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is this year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get end of week
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Add days to date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Subtract days from date
  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  /// Add months to date
  static DateTime addMonths(DateTime date, int months) {
    return DateTime(date.year, date.month + months, date.day);
  }

  /// Subtract months from date
  static DateTime subtractMonths(DateTime date, int months) {
    return DateTime(date.year, date.month - months, date.day);
  }

  /// Get age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Get days between two dates
  static int getDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  /// Get months between two dates
  static int getMonthsBetween(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;
  }

  /// Get years between two dates
  static int getYearsBetween(DateTime startDate, DateTime endDate) {
    return endDate.year - startDate.year;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Get current timestamp
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Convert timestamp to date
  static DateTime timestampToDate(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Convert date to timestamp
  static int dateToTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch;
  }
} 