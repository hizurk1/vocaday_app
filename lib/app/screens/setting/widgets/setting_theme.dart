part of '../setting_page.dart';

class _SettingTheme extends StatelessWidget {
  void _onChangedTheme(ThemeMode? value, BuildContext context) {
    if (value != null) {
      context.read<ThemeCubit>().toggleTheme(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      leading: Icon(
        context.isDarkTheme
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
        size: 25.r,
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
}
