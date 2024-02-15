import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListTileCustom extends StatelessWidget {
  const ListTileCustom({
    super.key,
    this.leading,
    required this.title,
    this.padding,
    this.subTitlePadding = 2,
    this.subTitle,
    this.titlePadding,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subTitle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? titlePadding;
  final double subTitlePadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: titlePadding ?? EdgeInsets.only(right: 10.w),
            child: leading ?? const SizedBox(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subTitle != null) SizedBox(height: subTitlePadding.h),
              subTitle ?? const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
