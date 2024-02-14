import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_asset.dart';
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                image ?? AppAssets.errorCat,
                width: 180.w,
                height: 180.h,
              ),
              Gap(height: 5.h),
              TextCustom(
                text,
                style: context.textStyle.bodyS.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
