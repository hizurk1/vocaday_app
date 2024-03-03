import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();
  static final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColor().white,
    cardColor: AppColor().white,
    primaryColor: AppColor().blue,
    primaryColorDark: AppColor().blue700,
    dialogBackgroundColor: AppColor().white,
    tabBarTheme: TabBarTheme(
      indicatorColor: AppColor().white,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor().backgroundLight,
      surfaceTintColor: AppColor().backgroundLight,
      modalBackgroundColor: AppColor().backgroundLight,
    ),
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
    scaffoldBackgroundColor: AppColor().black,
    cardColor: AppColor().grey900,
    primaryColor: AppColor().blue600,
    primaryColorDark: AppColor().blue400,
    dialogBackgroundColor: AppColor().black,
    tabBarTheme: TabBarTheme(
      indicatorColor: AppColor().grey700,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor().backgroundDark,
      surfaceTintColor: AppColor().backgroundDark,
      modalBackgroundColor: AppColor().backgroundDark,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor().blue,
      brightness: Brightness.dark,
      error: AppColor().red300,
      background: AppColor().black,
    ),
    textTheme: const TextTheme().apply(
      displayColor: AppColor().white,
      bodyColor: AppColor().white,
    ),
  );
}
