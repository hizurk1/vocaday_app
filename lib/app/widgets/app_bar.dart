import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_element.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';
import 'text.dart';

/// A custom app bar that can be used in the application.
///
/// This app bar has a customizable title, leading widget, and actions. The
/// title and leading widget can be centered or aligned to the start or end of
/// the app bar. The actions can be placed on the right or left of the title.
///
/// The app bar also has an optional padding on the left and right sides, which
/// can be disabled. By default, the padding is enabled.
///
/// The app bar uses the [SafeArea] widget to ensure that the content is
/// displayed correctly on different devices.
class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom app bar.
  const AppBarCustom({
    super.key,
    this.child,
    this.leading,
    this.action,
    this.title,
    this.textTitle,
    this.appBarHeight,
    this.enablePadding = false,
    this.centerTitle = true,
    this.enableShadow = true,
    this.transparent = false,
  });

  /// Transparent background of app bar.
  final bool transparent;

  /// If this widget is null. By default, the app bar uses the [Row] widget
  /// with [leading], [title] and [action] to show the content of the appbar.
  final Widget? child;

  /// A widget to display in the leading position.
  final Widget? leading;

  /// A widget to display in the trailing position.
  final Widget? action;

  /// The primary content of the app bar.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The text to display in the app bar.
  ///
  /// If this is specified, [title] is ignored.
  final String? textTitle;

  /// Whether to add padding to the left and right of the app bar.
  ///
  /// The default value is false.
  final bool enablePadding;

  /// Whether to center the title within the app bar.
  ///
  /// If false, the title is aligned to the start of the app bar.
  /// The default value is true.
  final bool centerTitle;

  /// The height of the app bar.
  ///
  /// The default value is [AppElement.appBarHeight]
  final double? appBarHeight;

  /// The shadow below the app bar.
  ///
  /// The default value is `true`.
  final bool enableShadow;

  @override
  Size get preferredSize => Size.fromHeight(
        appBarHeight ?? AppElement.appBarHeight.h,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: appBarHeight,
      padding: enablePadding ? EdgeInsets.symmetric(horizontal: 10.w) : null,
      decoration: BoxDecoration(
        color: transparent
            ? Colors.transparent
            : (context.isDarkTheme
                ? AppColor().backgroundDark
                : AppColor().white),
        boxShadow: enableShadow && !transparent
            ? [
                BoxShadow(
                  color: context.colors.grey400.withOpacity(.5),
                  blurRadius: 1,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: child ??
              Row(
                children: [
                  leading ?? SizedBox(width: 50.w),
                  Expanded(
                    child: centerTitle
                        ? Center(
                            child: title ??
                                TextCustom(
                                  textTitle ?? '',
                                  textAlign: TextAlign.center,
                                  style: context.textStyle.bodyL.bw,
                                ),
                          )
                        : title ??
                            TextCustom(
                              textTitle ?? '',
                              textAlign: TextAlign.center,
                              style: context.textStyle.titleM.bw,
                            ),
                  ),
                  action ?? SizedBox(width: 50.w),
                ],
              ),
        ),
      ),
    );
  }
}
