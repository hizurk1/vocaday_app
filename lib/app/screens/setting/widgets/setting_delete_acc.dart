part of '../setting_page.dart';

class _SettingDeleteAcc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
