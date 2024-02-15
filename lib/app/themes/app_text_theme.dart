import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../managers/navigation.dart';
import 'app_color.dart';

extension TextThemeExt on BuildContext {
  AppTextStyle get textStyle => AppTextStyle(); // context.textStyle
}

extension TextStyleExt on TextStyle {
  /// fontWeight: bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// color: white
  TextStyle get white => copyWith(color: AppColor().white);

  /// color: black
  TextStyle get black => copyWith(color: AppColor().black);

  /// color: blue/primary
  TextStyle get primary => copyWith(
        color: Navigators().currentContext!.isDarkTheme
            ? AppColor().blue300
            : AppColor().blue,
      );

  /// color: black & white
  TextStyle get bw => copyWith(
        color: Navigators().currentContext!.isDarkTheme
            ? AppColor().white
            : AppColor().black,
      );

  /// color: `grey`
  TextStyle get grey => copyWith(
        color: Navigators().currentContext!.isDarkTheme
            ? AppColor().grey300
            : AppColor().grey,
      );

  /// color: `grey300`
  TextStyle get grey300 => copyWith(color: AppColor().grey300);

  /// color: `grey` with opacity 80%
  TextStyle get grey80 => copyWith(color: AppColor().grey.withOpacity(.8));
}

class AppTextStyle {
  AppTextStyle._init();
  static final AppTextStyle _instance = AppTextStyle._init();
  factory AppTextStyle() => _instance;

  //! Title
  /// fontSize: 20 [normal]
  final TextStyle titleS = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 24 [w500]
  final TextStyle titleM = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  /// fontSize: 28 [bold]
  final TextStyle titleL = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
  );
  //! Body
  /// fontSize: 14 [normal]
  final TextStyle bodyS = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 16 [normal]
  final TextStyle bodyM = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 18 [normal]
  final TextStyle bodyL = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
  );
  //! Label
  /// fontSize: 10 [normal]
  final TextStyle labelS = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
  );

  /// fontSize: 11 [w500]
  final TextStyle labelM = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
  );

  /// fontSize: 12 [bold]
  final TextStyle labelL = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );
  //! Caption
  /// fontSize: 13 [w300]
  final TextStyle caption = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
  );
}
