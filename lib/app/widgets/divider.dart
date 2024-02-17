import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';

class DividerCustom extends StatelessWidget {
  const DividerCustom({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.opacity,
    this.color,
  });

  final double? width;
  final double? height;
  final double? opacity;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height?.h ?? 1.h,
      width: width?.w ?? context.screenWidth,
      margin: margin,
      color: color ?? context.greyColor.withOpacity(opacity ?? 0.5),
    );
  }
}
