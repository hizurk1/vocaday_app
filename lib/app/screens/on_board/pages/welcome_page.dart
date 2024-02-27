import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/gen/assets.gen.dart';
import '../../../themes/app_text_theme.dart';
import '../../../translations/translations.dart';
import '../../../widgets/gap.dart';
import '../../../widgets/text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ),
        child: Column(
          children: [
            Expanded(
              child: LottieBuilder.asset(
                Assets.jsons.manFlyingOnPaperAirplane,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextCustom(
                    LocaleKeys.on_board_onboard_title.tr(),
                    textAlign: TextAlign.center,
                    style: context.textStyle.titleL.bw,
                  ),
                  Gap(height: 20.h),
                  TextCustom(
                    LocaleKeys.on_board_onboard_body.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: context.textStyle.bodyM.grey,
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
