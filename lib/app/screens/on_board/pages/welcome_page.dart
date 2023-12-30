import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/app_asset.dart';
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
                AppAssets.manPaperAirPlane,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextCustom(
                    LocaleKeys.on_board_onboard_title.tr(),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    textAlign: TextAlign.center,
                  ),
                  Gap(height: 20.h),
                  TextCustom(
                    LocaleKeys.on_board_onboard_body.tr(),
                    textAlign: TextAlign.center,
                    height: 1.5,
                    maxLines: 3,
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
