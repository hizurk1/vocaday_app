import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  int get gridRatio => MediaQuery.of(this).size.width > 900
      ? 3
      : MediaQuery.of(this).size.width > 600
          ? 2
          : 1;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  Brightness get brightness => Theme.of(this).brightness;
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
  Color get backgroundColor => theme.colorScheme.background;
}
