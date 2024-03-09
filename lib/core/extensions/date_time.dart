import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExt on TimeOfDay {
  String get getHHmm {
    return '$hour:${minute < 10 ? '0$minute' : minute}';
  }

  String get getHHmmaa {
    final hourOfDay = hourOfPeriod;
    final period = hour < 12 ? 'AM' : 'PM';
    return '${hourOfDay < 10 ? '0$hourOfDay' : hourOfDay}:${minute < 10 ? '0$minute' : minute} $period';
  }
}

extension DateTimeNExt on DateTime? {
  /// Format Datetime to `dd/MM/yyyy` string
  String? get ddMMyyyy {
    if (this == null) return null;
    return DateFormat('dd/MM/yyyy').format(this!);
  }
}

extension DateTimeExt on DateTime {
  /// Reset given Datetime to Datetime with time set to `00:00:00`
  DateTime get resetTime => DateTime(year, month, day);

  /// Format Datetime to `dd/MM/yyyy HH:mm aa` string
  String get ddMMyyyyHHmmaa => DateFormat('dd/MM/yyyy HH:mm aa').format(this);

  /// Format Datetime to `dd/MM/yyyy HH:mm` string
  String get ddMMyyyyHHmm => DateFormat('dd/MM/yyyy HH:mm').format(this);

  /// Format Datetime to `dd/MM/yyyy` string
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  /// compare 2 DateTime. Returns `true` if `this` > `other`.
  bool greaterThanDMY(DateTime other) {
    if (year > other.year) {
      return true;
    } else if (year == other.year) {
      if (month > other.month) {
        return true;
      } else if (month == other.month) {
        if (day > other.day) {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if a given date falls within the current week.
  ///
  /// The week is now adjusted to Sunday - Saturday, instead of Monday - Sunday as normal.
  bool get isInCurrentWeek {
    DateTime now = DateTime.now();

    // Find the start of the current week (Sunday)
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    // Use this if you want to start the week from Monday.
    // DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

    // Find the end of the current week (Saturday)
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Check if the given date falls between the start and end of the current week
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if a given date falls within the current month.
  bool get isInCurrentMonth {
    DateTime now = DateTime.now();
    return month == now.month;
  }
}
