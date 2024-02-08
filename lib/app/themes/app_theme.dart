import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();
  static final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColor().background,
    cardColor: AppColor().white,
    primaryColorDark: AppColor().primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor().primary,
      brightness: Brightness.light,
      error: AppColor().error,
    ),
    textTheme: const TextTheme().apply(
      displayColor: AppColor().primaryText,
      bodyColor: AppColor().primaryText,
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColor().backgroundDark,
    cardColor: AppColor().cardDark,
    primaryColor: AppColor().primaryLight,
    primaryColorDark: AppColor().primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor().primary,
      brightness: Brightness.dark,
      error: AppColor().error,
    ),
    textTheme: const TextTheme().apply(
      displayColor: AppColor().white,
      bodyColor: AppColor().white,
    ),
  );
}
