import 'package:flutter/material.dart';

import '../../app/themes/app_color.dart';

extension BuildContextExtension on BuildContext {
  /// Get screen size of current context
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width of current context
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height of current context
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get screen ratio of current context, for different devices
  int get gridRatio => MediaQuery.of(this).size.width > 900
      ? 3
      : MediaQuery.of(this).size.width > 600
          ? 2
          : 1;

  /// Get text theme of current context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get theme of current context
  ThemeData get theme => Theme.of(this);

  /// Get brightness of current context
  Brightness get brightness => Theme.of(this).brightness;

  /// Get [bool] state of current context is dark or not
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Get [Color], different with [theme.scaffoldBackgroundColor],
  /// this attribute has lighter color.
  Color get backgroundColor =>
      isDarkTheme ? AppColor().backgroundDark : AppColor().white;
}
