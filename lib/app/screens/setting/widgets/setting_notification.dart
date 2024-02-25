// ignore_for_file: must_be_immutable

part of '../setting_page.dart';

class _SettingNotification extends StatefulWidget {
  @override
  State<_SettingNotification> createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<_SettingNotification> {
  ValueNotifier<bool> showNofi = ValueNotifier(false);
  ValueNotifier<TimeOfDay?> timeNoti = ValueNotifier(null);

  final cubit = ScheduleNotificationCubit();

  Future<TimeOfDay?> _onSelectScheduleTime() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future _onSetNotification(bool isTurnOn, BuildContext context) async {
    if (isTurnOn) {
      final pickedTime = await _onSelectScheduleTime();
      if (pickedTime != null && mounted) {
        timeNoti.value = pickedTime;
        showNofi.value = true;
        Navigators().showLoading(
          delay: Durations.long2,
          tasks: [
            context
                .read<ScheduleNotificationCubit>()
                .setScheduleNotification(pickedTime),
          ],
          onFinish: () {
            Navigators().showMessage(
              LocaleKeys.setting_notification_set_to.tr(
                args: [pickedTime.getHHmm],
              ),
              type: MessageType.success,
            );
          },
        );
      }
    } else {
      timeNoti.value = null;
      showNofi.value = false;
      await context
          .read<ScheduleNotificationCubit>()
          .cancelScheduleNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    timeNoti.value = sl<SharedPrefManager>().getScheduleNotiTime;
    showNofi.value = timeNoti.value != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: ListTileCustom(
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
        subTitle: ValueListenableBuilder(
          valueListenable: timeNoti,
          builder: (context, TimeOfDay? time, _) {
            if (time != null) {
              return TextCustom(
                LocaleKeys.setting_remind_at.tr(
                  args: [time.getHHmm],
                ),
                style: context.textStyle.caption.grey,
              );
            }
            return const SizedBox();
          },
        ),
        trailing: ValueListenableBuilder(
          valueListenable: showNofi,
          builder: (context, bool value, _) {
            return CupertinoSwitch(
              value: value,
              activeColor: context.theme.primaryColor,
              onChanged: (newValue) => _onSetNotification(newValue, context),
            );
          },
        ),
      ),
    );
  }
}
