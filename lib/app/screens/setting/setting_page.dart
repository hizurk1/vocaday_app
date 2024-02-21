import 'package:flutter/cupertino.dart';
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
            _buildTitle(context, LocaleKeys.setting_general.tr()),
            _buildLanguage(context),
            _buildTheme(context),
            _buildNotification(context),
            _buildTitle(context, LocaleKeys.setting_others.tr()),
            _buildRateApp(context),
            _buildCheckUpdate(context),
            _buildPrivacyPolicy(context),
            _buildAboutUs(context),
            _buildTitle(context, LocaleKeys.setting_danger_zone.tr()),
            _buildDeleteAcc(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAcc(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      leading: const Icon(
        Icons.group_remove_outlined,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_delete_acc.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.greyColor,
        size: 18,
      ),
    );
  }

  Widget _buildAboutUs(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      leading: const Icon(
        Icons.info_outline,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_about_us.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.greyColor,
        size: 18,
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      leading: const Icon(
        Icons.privacy_tip_outlined,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_privacy_policy.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.greyColor,
        size: 18,
      ),
    );
  }

  Widget _buildCheckUpdate(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      leading: const Icon(
        Icons.replay_outlined,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_check_for_update.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.greyColor,
        size: 18,
      ),
    );
  }

  Widget _buildRateApp(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      leading: const Icon(
        Icons.star_border_rounded,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_rate_app.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.greyColor,
        size: 18,
      ),
    );
  }

  Widget _buildNotification(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      leading: const Icon(
        Icons.notifications_none,
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_turn_on_notification.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: CupertinoSwitch(
        value: false,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildTheme(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
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
    );
  }

  Widget _buildLanguage(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
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
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      color: context.greyColor.withOpacity(.15),
      child: TextCustom(
        text,
        style: context.textStyle.caption.grey,
      ),
    );
  }
}
