import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../core/extensions/build_context.dart';

class TopTabBar extends StatelessWidget {
  const TopTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyL = context.textStyle.bodyL;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: TabBar(
        indicatorWeight: 4,
        labelPadding: EdgeInsets.only(bottom: 5.h),
        labelStyle: bodyL.bold.bw,
        unselectedLabelStyle: bodyL.grey,
        indicatorColor: context.isDarkTheme
            ? context.colors.grey400
            : context.colors.grey800,
        indicatorPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: LocaleKeys.auth_sign_in.tr()),
          Tab(text: LocaleKeys.auth_sign_up.tr()),
        ],
      ),
    );
  }
}
