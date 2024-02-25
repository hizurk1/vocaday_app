part of '../setting_page.dart';

class _SettingPrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
