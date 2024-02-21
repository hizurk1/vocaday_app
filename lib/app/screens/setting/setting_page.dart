import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/build_context.dart';
import '../../managers/language.dart';
import '../../managers/theme.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_tile_custom.dart';
import '../../widgets/text.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _onChangedLanguage(Locale? value, BuildContext context) async {
    if (value != null) {
      context.read<LanguageCubit>().changeLanguage(value);
      await context.setLocale(value);
    }
  }

  void _onChangedTheme(ThemeMode? value, BuildContext context) {
    if (value != null) {
      context.read<ThemeCubit>().toggleTheme(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBarCustom(
        leading: const BackButton(),
        textTitle: LocaleKeys.page_setting.tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              color: context.greyColor.withOpacity(.15),
              child: TextCustom(
                LocaleKeys.setting_general.tr(),
                style: context.textStyle.caption.grey,
              ),
            ),
            ListTileCustom(
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              leading: const Icon(Icons.language),
              titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
              title: TextCustom(
                LocaleKeys.setting_language.tr(),
                style: context.textStyle.bodyS.bw,
              ),
              trailing: DropdownButton(
                underline: const SizedBox(),
                value: context.locale,
                onChanged: (value) => _onChangedLanguage(value, context),
                elevation: 1,
                items: [
                  DropdownMenuItem(
                    value: AppLocale.en.instance,
                    child: TextCustom(
                      LocaleKeys.app_language_english.tr(),
                      style: context.textStyle.caption.bw,
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppLocale.vi.instance,
                    child: TextCustom(
                      LocaleKeys.app_language_vietnamese.tr(),
                      style: context.textStyle.caption.bw,
                    ),
                  ),
                ],
              ),
            ),
            ListTileCustom(
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              leading: Icon(
                context.isDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
              title: TextCustom(
                LocaleKeys.setting_theme_mode.tr(),
                style: context.textStyle.bodyS.bw,
              ),
              trailing: DropdownButton(
                underline: const SizedBox(),
                value: context.watch<ThemeCubit>().state.themeMode,
                onChanged: (value) => _onChangedTheme(value, context),
                elevation: 1,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: TextCustom(
                      LocaleKeys.setting_theme_system.tr(),
                      style: context.textStyle.caption.bw,
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: TextCustom(
                      LocaleKeys.setting_theme_light.tr(),
                      style: context.textStyle.caption.bw,
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: TextCustom(
                      LocaleKeys.setting_theme_dark.tr(),
                      style: context.textStyle.caption.bw,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
