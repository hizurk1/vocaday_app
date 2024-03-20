import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';

class LoadingIndicatorPage extends StatelessWidget {
  const LoadingIndicatorPage({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 20.h),
        child: const LoadingIndicatorWidget(),
      ),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    super.key,
    this.color,
    this.size,
  });

  final Color? color;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.height.r ?? 25.r,
      width: size?.width.r ?? 25.r,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? context.theme.primaryColor,
      ),
    );
  }
}
