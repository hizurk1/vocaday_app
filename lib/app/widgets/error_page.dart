import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../core/extensions/build_context.dart';
import '../constants/gen/assets.gen.dart';
import '../themes/app_text_theme.dart';
import 'gap.dart';
import 'text.dart';
import 'unfocus.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.text, this.image, this.info});

  /// Error message.
  final String text;

  /// Must be using `Assets.json` for Lottie package.
  final String? image;

  /// For more info widget that shows under the text widget.
  final Widget? info;

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
                Opacity(
                  opacity: context.isDarkTheme ? 0.85 : 1,
                  child: Lottie.asset(
                    image ?? Assets.jsons.error,
                    width: 180.w,
                    height: 180.h,
                  ),
                ),
                Gap(height: 5.h),
                TextCustom(
                  text,
                  style: context.textStyle.bodyS.grey,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
                if (info != null) ...[
                  Gap(height: 5.h),
                  info!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
