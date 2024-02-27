import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../constants/gen/assets.gen.dart';
import '../../../managers/language.dart';
import '../../../themes/app_text_theme.dart';
import '../../../translations/translations.dart';
import '../../../widgets/gap.dart';
import '../../../widgets/text.dart';
import '../widgets/select_language_options.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SvgPicture.asset(
                  Assets.images.languageSelect,
                  height: context.screenHeight / 3,
                ),
                const Gap(height: 10),
                TextCustom(
                  LocaleKeys.on_board_select_language.tr(),
                  style: context.textStyle.titleL.bw,
                ),
                const Gap(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: TextCustom(
                    LocaleKeys.on_board_select_language_content.tr(),
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyM.grey,
                    maxLines: 3,
                  ),
                ),
                const Gap(height: 30),
                const SelectLanguageOptionsWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
