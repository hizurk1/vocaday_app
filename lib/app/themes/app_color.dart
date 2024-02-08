import 'package:flutter/material.dart';

extension AppColorExt on BuildContext {
  AppColor get colors => AppColor(); // context.colors
}

class AppColor {
  AppColor._init();

  static final AppColor _instance = AppColor._init();
  factory AppColor() => _instance;

  final white = const Color(0xFFFFFFFF);
  final black = const Color(0xFF000000);
  final grey = const Color(0xFFA8A8A8);

  final primary = const Color(0xFF3D49DE);
  final primaryDark = const Color.fromARGB(255, 11, 41, 152);
  final primaryLight = const Color(0xFF494F79);
  final primaryLighter = const Color(0xFFE7EAEF);
  final primaryText = const Color(0xFF000000);
  final secondaryText = const Color(0xFFA8A8A8);
  final cardDark = const Color(0xFF1E1E1E);
  final background = const Color.fromARGB(255, 242, 242, 242);
  final backgroundDark = const Color(0xFF222222);
  final error = const Color.fromARGB(255, 232, 53, 30);
  final accent = const Color(0xFFED705F);
  final divider = const Color(0xFFBABFC2);
  final drawer = const Color.fromARGB(255, 0, 20, 64);
}
