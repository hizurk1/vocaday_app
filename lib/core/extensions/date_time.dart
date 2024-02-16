import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
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
}
