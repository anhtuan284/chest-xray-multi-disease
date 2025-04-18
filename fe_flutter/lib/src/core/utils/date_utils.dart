import 'package:intl/intl.dart';

/// Utility class for date-related operations
class MoodDateUtils {
  /// Format a date to display in header (e.g., "FEB 2024")
  static String formatDateHeader(DateTime date, bool isMonthly) {
    if (isMonthly) {
      return DateFormat('MMM yyyy').format(date).toUpperCase();
    } else {
      return date.year.toString();
    }
  }

  /// Format a date for displaying in chart titles (e.g., "February 2024")
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Format day of month (with leading zero)
  static String formatDayOfMonth(int day) {
    return day.toString().padLeft(2, '0');
  }

  /// Format just the day (without month)
  static String formatDay(DateTime date) {
    return DateFormat('d').format(date);
  }

  /// Format day with month (e.g., "15 Feb")
  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  /// Get the month abbreviation for a given month number (1-12)
  static String getMonthAbbreviation(int month) {
    final date = DateTime(2023, month); // Year doesn't matter
    return DateFormat('MMM').format(date);
  }

  /// Get the full month name for a given month abbreviation
  static String getFullMonthName(String abbreviation) {
    final Map<String, String> monthMap = {
      'Jan': 'January',
      'Feb': 'February',
      'Mar': 'March',
      'Apr': 'April',
      'May': 'May',
      'Jun': 'June',
      'Jul': 'July',
      'Aug': 'August',
      'Sep': 'September',
      'Oct': 'October',
      'Nov': 'November',
      'Dec': 'December',
    };

    return monthMap[abbreviation] ?? abbreviation;
  }

  /// Get all month abbreviations
  static List<String> getAllMonthAbbreviations() {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
  }

  /// Get all month names
  static List<String> getAllMonthNames() {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  /// Get months in a specific quarter (1-4)
  static List<String> getMonthsInQuarter(int quarter) {
    final monthNames = getAllMonthAbbreviations();

    switch (quarter) {
      case 1:
        return monthNames.sublist(0, 3);
      case 2:
        return monthNames.sublist(3, 6);
      case 3:
        return monthNames.sublist(6, 9);
      case 4:
        return monthNames.sublist(9, 12);
      default:
        return monthNames.sublist(0, 3);
    }
  }

  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return getAllMonthNames()[month - 1];
  }

  /// Get the number of days in a month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Get the first day of the month
  static DateTime getFirstDayOfMonth(int year, int month) {
    return DateTime(year, month, 1);
  }

  /// Get the last day of the month
  static DateTime getLastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0);
  }

  /// Get the current week number (1-based) for a given date
  static int getCurrentWeekOfMonth(DateTime date) {
    final daysSinceMonthStart = date.day - 1;
    return (daysSinceMonthStart / 7).floor() + 1;
  }

  /// Get the current quarter (1-4) for a given date
  static int getCurrentQuarter(DateTime date) {
    return ((date.month - 1) / 3).floor() + 1;
  }
}
