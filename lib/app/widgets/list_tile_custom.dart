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
    this.trailing,
    this.titlePadding,
    this.decoration,
    this.width,
    this.height,
    this.minHeight,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subTitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? titlePadding;
  final double subTitlePadding;
  final BoxDecoration? decoration;
  final double? width, height;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      height: height,
      width: width,
      decoration: decoration,
      constraints: minHeight != null
          ? BoxConstraints(
              minHeight: minHeight!,
            )
          : null,
      child: Row(
        children: [
          leading ?? const SizedBox(),
          Expanded(
            child: Padding(
              padding: titlePadding ?? EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subTitle != null) SizedBox(height: subTitlePadding.h),
                  subTitle ?? const SizedBox(),
                ],
              ),
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}
