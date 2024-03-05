import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../themes/app_color.dart';
import '../../../../../themes/app_text_theme.dart';
import '../../../../../translations/translations.dart';
import '../../../../../widgets/widgets.dart';

class ProfileInfoItemWidget extends StatelessWidget {
  const ProfileInfoItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  final String icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 28.w,
            height: 28.h,
            colorFilter: ColorFilter.mode(
              context.colors.grey300,
              BlendMode.srcIn,
            ),
          ),
          const Gap(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextCustom(
                  title,
                  style: context.textStyle.labelM.bold.grey300,
                ),
                const Gap(height: 3),
                TextCustom(
                  content.isNotEmpty
                      ? content
                      : "(${LocaleKeys.profile_no_info.tr()})",
                  style: context.textStyle.bodyS.bw.copyWith(
                    fontStyle: content.isEmpty ? FontStyle.italic : null,
                    color: content.isEmpty ? context.colors.grey : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  height: 1,
                  color: context.colors.grey300.withOpacity(.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
