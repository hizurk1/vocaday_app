import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/themes/app_color.dart';

class AuthCardContainerWidget extends StatelessWidget {
  const AuthCardContainerWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.screenHeight / 16),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h)
          .copyWith(bottom: 30.h),
      width: context.screenWidth - 60.w,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.colors.grey800.withOpacity(.05),
            spreadRadius: 10,
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
