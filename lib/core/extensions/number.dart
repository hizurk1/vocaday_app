import 'package:intl/intl.dart';

extension DoubleExtension on double {
  double get toPercentage {
    final percentage = this * 100;
    final formatter = NumberFormat.decimalPattern('en_US');
    return double.parse(formatter.format(percentage));
  }

  String get toPercentageString {
    final percentage = this * 100;
    final formatter = NumberFormat.decimalPattern('en_US');
    return '${formatter.format(percentage)}%';
  }
}

extension IntExt on int {
  String get to99plus => this > 99 ? "99+" : toString();
}
