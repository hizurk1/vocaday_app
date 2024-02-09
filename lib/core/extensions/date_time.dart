import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);
}
