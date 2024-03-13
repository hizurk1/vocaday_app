import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../themes/app_color.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/text.dart';

class MenuDrawerTile extends StatelessWidget {
  const MenuDrawerTile({
    super.key,
    required this.onTap,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.title,
  });

  final VoidCallback onTap;
  final int index;
  final int selectedIndex;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w / 2),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 54.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: selectedIndex == index
                    ? context.theme.primaryColor
                    : Colors.transparent,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                icon,
                height: 25.r,
                width: 25.r,
                colorFilter:
                    ColorFilter.mode(context.colors.white, BlendMode.srcIn),
              ),
              horizontalTitleGap: 15.w,
              title: TextCustom(
                title,
                style: context.textStyle.bodyM.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
