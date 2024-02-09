import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_element.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';
import 'text.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    this.child,
    this.leading,
    this.action,
    this.title,
    this.textTitle,
    this.centerTitle = true,
  });

  final Widget? child;
  final Widget? leading;
  final Widget? action;
  final Widget? title;
  final String? textTitle;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(AppElement.appBarSize.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        color:
            context.isDarkTheme ? AppColor().backgroundDark : AppColor().white,
        boxShadow: [
          BoxShadow(
            color: context.colors.grey400.withOpacity(.5),
            blurRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
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
    );
  }
}
