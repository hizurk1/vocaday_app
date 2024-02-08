import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../managers/navigation.dart';
import 'app_color.dart';

extension TextThemeExt on BuildContext {
  AppTextStyle get textStyle => AppTextStyle();
}

extension TextStyleExt on TextStyle {
  TextStyle get bw => copyWith(
        color: Navigators().currentContext!.isDarkTheme
            ? Colors.white
            : Colors.black,
      );
  TextStyle get g => copyWith(
        color: Navigators().currentContext!.isDarkTheme
            ? AppColor().grey
            : AppColor().grey700,
      );
}

class AppTextStyle {
  AppTextStyle._init();
  static final AppTextStyle _instance = AppTextStyle._init();
  factory AppTextStyle() => _instance;

  //! Title
  final TextStyle titleS = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle titleM = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle titleL = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  //! Body
  final TextStyle bodyS = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle bodyM = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle bodyL = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  //! Label
  final TextStyle labelS = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle labelM = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  final TextStyle labelL = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    wordSpacing: 1,
  );
  //! Caption
  final TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w200,
    letterSpacing: 1,
    wordSpacing: 1,
  );
}
