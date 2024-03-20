part of '../setting_page.dart';

class _SettingPrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => UtilFunction.launchUrl(AppStringConst.privacyPolicyUrl),
      child: ListTileCustom(
        minHeight: 60.h,
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        leading: SvgPicture.asset(
          Assets.icons.privacy,
          height: 25.r,
          width: 25.r,
          colorFilter: ColorFilter.mode(context.bwColor, BlendMode.srcIn),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: TextCustom(
          LocaleKeys.setting_privacy_policy.tr(),
          style: context.textStyle.bodyS.bw,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: context.greyColor,
          size: 18.r,
        ),
      ),
    );
  }
}
