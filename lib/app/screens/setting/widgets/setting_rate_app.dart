part of '../setting_page.dart';

class _SettingRateApp extends StatelessWidget {
  Future<void> _inAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _inAppReview(),
      child: ListTileCustom(
        minHeight: 60.h,
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        leading: SvgPicture.asset(
          Assets.icons.rateApp,
          height: 25.r,
          width: 25.r,
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
          size: 18.r,
        ),
      ),
    );
  }
}
