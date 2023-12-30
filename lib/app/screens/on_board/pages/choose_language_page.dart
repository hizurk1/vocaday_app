import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../constants/app_asset.dart';
import '../../../translations/translations.dart';
import '../../../widgets/gap.dart';
import '../../../widgets/text.dart';
import '../widgets/select_language_options.dart';

class ChooseLanguagePage extends StatelessWidget {
  const ChooseLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SvgPicture.asset(
            AppAssets.onBoardLanguage,
            height: context.screenHeight / 3,
          ),
          const Gap(height: 10),
          TextCustom(
            LocaleKeys.on_board_select_language.tr(),
            textAlign: TextAlign.center,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.textTheme.bodyLarge?.color,
          ),
          const Gap(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: TextCustom(
              LocaleKeys.on_board_select_language_content.tr(),
              textAlign: TextAlign.center,
              height: 1.5,
              color: context.textTheme.bodyMedium?.color,
            ),
          ),
          const Gap(height: 30),
          const SelectLanguageOptionsWidget(),
        ],
      ),
    );
  }
}
