part of '../setting_page.dart';

class _SettingDeleteAcc extends StatelessWidget {
  _onDeleteAccountPopup(BuildContext context) {
    context.showBottomSheet(
      child: SettingDeleteAccountBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onDeleteAccountPopup(context),
      child: ListTileCustom(
        minHeight: 60.h,
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        leading: SvgPicture.asset(
          Assets.icons.deleteAcc,
          height: 25.r,
          width: 25.r,
          colorFilter: ColorFilter.mode(context.bwColor, BlendMode.srcIn),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: TextCustom(
          LocaleKeys.setting_delete_acc.tr(),
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
