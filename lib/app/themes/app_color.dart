import 'package:flutter/material.dart';

extension AppColorExt on BuildContext {
  AppColor get colors => AppColor(); // context.colors
}

class AppColor {
  AppColor._init();
  static final AppColor _instance = AppColor._init();
  factory AppColor() => _instance;

  final Color white = const Color(0xFFFFFFFF);
  final Color black = const Color(0xFF000000);
  final Color backgroundLight = const Color(0xFFfafafa);
  final Color backgroundDark = const Color(0xFF0f0f0f);
  //* Grey
  final Color grey = const Color(0xFF8c8c8c); // 500
  final Color grey100 = const Color(0xFFf2f2f2);
  final Color grey150 = const Color(0xFFececec);
  final Color grey200 = const Color(0xFFd9d9d9);
  final Color grey300 = const Color(0xFFbfbfbf);
  final Color grey400 = const Color(0xFFa6a6a6);
  final Color grey500 = const Color(0xFF8c8c8c);
  final Color grey600 = const Color(0xFF737373);
  final Color grey700 = const Color(0xFF595959);
  final Color grey800 = const Color(0xFF404040);
  final Color grey900 = const Color(0xFF262626);
  final Color grey950 = const Color(0xFF1a1a1a);
  //* Blue
  final Color blue = const Color(0xFF3b47de); // 500
  final Color blue100 = const Color(0xFFe9ebfb);
  final Color blue200 = const Color(0xFFbec2f4);
  final Color blue300 = const Color(0xFF9299ec);
  final Color blue400 = const Color(0xFF6670e5);
  final Color blue500 = const Color(0xFF3b47de);
  final Color blue600 = const Color(0xFF212ec4);
  final Color blue700 = const Color(0xFF1a2399);
  final Color blue800 = const Color(0xFF13196d);
  final Color blue900 = const Color(0xFF0b0f41);
  //* Red
  final Color red = const Color(0xFFef2941); // 500
  final Color red100 = const Color(0xFFfde7ea);
  final Color red200 = const Color(0xFFfab8c0);
  final Color red300 = const Color(0xFFf68896);
  final Color red400 = const Color(0xFFf3596c);
  final Color red500 = const Color(0xFFef2941);
  final Color red600 = const Color(0xFFd61028);
  final Color red700 = const Color(0xFFa60c1f);
  final Color red800 = const Color(0xFF770916);
  final Color red900 = const Color(0xFF47050d);
  //* Green
  final Color green = const Color(0xFF5fba63); // 500
  final Color green100 = const Color(0xFFedf7ee);
  final Color green200 = const Color(0xFFcae8cb);
  final Color green300 = const Color(0xFFa6d8a8);
  final Color green400 = const Color(0xFF83c985);
  final Color green500 = const Color(0xFF5fba63);
  final Color green600 = const Color(0xFF45a049);
  final Color green700 = const Color(0xFF367c39);
  final Color green800 = const Color(0xFF275929);
  final Color green900 = const Color(0xFF173518);
}
