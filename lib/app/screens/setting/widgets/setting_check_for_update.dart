part of '../setting_page.dart';

class _SettingCheckUpdate extends StatelessWidget {
  final ValueNotifier<bool> updatingNotifier = ValueNotifier(false);

  Future<void> _checkForUpdate() async {
    updatingNotifier.value = true;
    final updateInfo = await InAppUpdate.checkForUpdate();
    updatingNotifier.value = false;
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      // Perform immediate update
      final result = await InAppUpdate.performImmediateUpdate();
      if (result == AppUpdateResult.success) {
        //App Update successful
        Navigators().showDialogWithButton(
          dissmisable: false,
          iconData: Icons.check,
          title: LocaleKeys.setting_update_success_please_restart.tr(),
          maxLinesTitle: 3,
          showAccept: false,
          showCancel: false,
        );
      }
    } else {
      Navigators().showMessage(
        LocaleKeys.setting_no_update_available.tr(),
        type: MessageType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _checkForUpdate(),
      child: ListTileCustom(
        minHeight: 60.h,
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        leading: SvgPicture.asset(
          Assets.icons.checkUpdate,
          height: 25.r,
          width: 25.r,
          colorFilter: ColorFilter.mode(context.bwColor, BlendMode.srcIn),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: TextCustom(
          LocaleKeys.setting_check_for_update.tr(),
          style: context.textStyle.bodyS.bw,
        ),
        trailing: ValueListenableBuilder(
          valueListenable: updatingNotifier,
          builder: (context, bool updating, _) {
            return updating
                ? LoadingIndicatorWidget(
                    color: context.greyColor,
                    size: Size.square(18.r),
                  )
                : Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: context.greyColor,
                    size: 18.r,
                  );
          },
        ),
      ),
    );
  }
}
