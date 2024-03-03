import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';

class DashedLineCustom extends StatelessWidget {
  const DashedLineCustom({
    super.key,
    this.lineColor,
    this.strokeWidth,
    this.dashSpace,
    this.dashWidth,
    this.padding,
    this.margin,
  });

  final Color? lineColor;
  final double? strokeWidth, dashSpace, dashWidth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: padding,
      margin: margin,
      child: CustomPaint(
        painter: DashedLinePainter(
          lineColor: lineColor ?? context.greyColor.withOpacity(.6),
          strokeWidth: strokeWidth ?? 1.h,
          dashSpace: dashSpace ?? 5.w,
          dashWidth: dashWidth ?? 9.w,
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth, dashWidth, dashSpace;

  DashedLinePainter({
    required this.lineColor,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
