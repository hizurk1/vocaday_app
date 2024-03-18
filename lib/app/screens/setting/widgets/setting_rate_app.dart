part of '../setting_page.dart';

class _SettingRateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        logger.d("Rate this app");
      },
      child: ListTileCustom(
        minHeight: 60.h,
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        leading: SvgPicture.asset(
          Assets.icons.rateApp,
          height: 25.h,
          width: 25.w,
          colorFilter: ColorFilter.mode(context.bwColor, BlendMode.srcIn),
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
      ),
    );
  }
}
