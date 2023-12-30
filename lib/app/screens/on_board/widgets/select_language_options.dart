import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_asset.dart';
import '../../../managers/language.dart';
import '../../../translations/translations.dart';
import '../../../widgets/gap.dart';
import 'language_option_tile.dart';

class SelectLanguageOptionsWidget extends StatefulWidget {
  const SelectLanguageOptionsWidget({super.key});

  @override
  State<SelectLanguageOptionsWidget> createState() =>
      _SelectLanguageOptionsWidgetState();
}

class _SelectLanguageOptionsWidgetState
    extends State<SelectLanguageOptionsWidget> {
  Future<void> setAppLanguage(AppLocale appLocale) async {
    await context.setLocale(appLocale.instance);
    if (mounted) {
      context.read<LanguageBloc>().add(SetLanguageEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          LanguageOptionWidget(
            onTap: () async => await setAppLanguage(AppLocale.en),
            text: LocaleKeys.app_language_english.tr(),
            icon: AppAssets.englishFlagRound,
            isSelected:
                context.locale.languageCode == AppLocale.en.languageCode,
          ),
          const Gap(height: 10),
          LanguageOptionWidget(
            onTap: () async => await setAppLanguage(AppLocale.vi),
            text: LocaleKeys.app_language_vietnamese.tr(),
            icon: AppAssets.vietNamFlagRound,
            isSelected:
                context.locale.languageCode == AppLocale.vi.languageCode,
          ),
        ],
      ),
    );
  }
}
