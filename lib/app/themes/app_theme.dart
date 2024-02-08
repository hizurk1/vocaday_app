import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();
  static final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColor().scaffoldBackground,
    cardColor: AppColor().white,
    primaryColor: AppColor().blue,
    primaryColorDark: AppColor().blue700,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor().blue,
      brightness: Brightness.light,
      error: AppColor().red,
      background: AppColor().white,
    ),
    textTheme: const TextTheme().apply(
      displayColor: AppColor().black,
      bodyColor: AppColor().grey800,
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColor().scaffoldBackgroundDark,
    cardColor: AppColor().grey600,
    primaryColor: AppColor().blue,
    primaryColorDark: AppColor().blue700,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor().blue,
      brightness: Brightness.dark,
      error: AppColor().red,
      background: AppColor().black,
    ),
    textTheme: const TextTheme().apply(
      displayColor: AppColor().white,
      bodyColor: AppColor().white,
    ),
  );
}
