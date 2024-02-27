import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../constants/gen/assets.gen.dart';
import '../themes/app_text_theme.dart';
import 'gap.dart';
import 'text.dart';
import 'unfocus.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.text, this.image});

  final String text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.h).copyWith(top: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  image ?? Assets.jsons.error,
                  width: 180.w,
                  height: 180.h,
                ),
                Gap(height: 5.h),
                TextCustom(
                  text,
                  style: context.textStyle.bodyS.grey,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
