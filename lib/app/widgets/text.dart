import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';

class TextCustom extends StatelessWidget {
  const TextCustom(
    this.text, {
    this.color,
    this.fontWeight,
    this.fontSize = 16,
    this.maxLines = 2,
    this.textAlign = TextAlign.start,
    this.height = 1,
    super.key,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  final int maxLines;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: context.theme.textTheme.bodyMedium!.copyWith(
        color: color,
        height: height,
        fontSize: fontSize.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      textAlign: textAlign,
    );
  }
}
