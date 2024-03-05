import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
import '../constants/gen/assets.gen.dart';
import 'widgets.dart';

class WordSmallCardWidget extends StatelessWidget {
  const WordSmallCardWidget({
    super.key,
    required this.onTap,
    required this.onRemove,
    required this.text,
  });

  final String text;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.cardColor,
      borderRadius: BorderRadius.circular(8.r),
      shadowColor: context.shadowColor.withOpacity(.5),
      elevation: 1.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 15.w,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListTileCustom(
            title: TextCustom(text),
            trailing: GestureDetector(
              onTap: onRemove,
              child: SvgPicture.asset(
                Assets.icons.closeCircle,
                colorFilter: ColorFilter.mode(
                  context.greyColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
