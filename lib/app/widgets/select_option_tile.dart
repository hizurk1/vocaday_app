import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';
import 'gap.dart';
import 'text.dart';

class SelectOptionTileWidget extends StatelessWidget {
  const SelectOptionTileWidget({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.text,
    this.style,
    this.icon,
    this.color,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String text;
  final TextStyle? style;
  final String? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Durations.short3,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(
          vertical: icon != null ? 10.h : 15.h,
          horizontal: 15.w,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? context.theme.primaryColor).withOpacity(.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? (color ?? context.colors.blue)
                : context.theme.dividerColor.withOpacity(.3),
            width: isSelected ? 2.5 : 2,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Durations.medium2,
              height: 24.r,
              width: 24.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000.r),
                border: Border.all(
                  color: isSelected
                      ? (color ?? context.colors.blue)
                      : context.theme.dividerColor.withOpacity(.4),
                  width: isSelected ? 8.r : 2.r,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
            ),
            const Gap(width: 20),
            Expanded(
              child: TextCustom(
                text,
                style: isSelected
                    ? (style ?? context.textStyle.bodyS.bold).copyWith(
                        color: color ?? context.colors.blue,
                      )
                    : (style ?? context.textStyle.bodyS.bold.grey),
              ),
            ),
            if (icon != null)
              SvgPicture.asset(
                icon!,
                height: 45.h,
              ),
          ],
        ),
      ),
    );
  }
}
