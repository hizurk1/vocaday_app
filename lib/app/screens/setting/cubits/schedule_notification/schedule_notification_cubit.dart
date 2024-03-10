import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/list.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../../injection_container.dart';
import '../../../../managers/navigation.dart';
import '../../../../managers/notification.dart';
import '../../../../managers/permission.dart';
import '../../../../managers/shared_preferences.dart';
import '../../../../translations/translations.dart';

part 'schedule_notification_state.dart';

class ScheduleNotificationCubit extends Cubit<ScheduleNotificationState> {
  ScheduleNotificationCubit() : super(ScheduleNotificationInitial());

  Future<bool> setScheduleNotification(TimeOfDay time) async {
    if (await PermissionManager.isGrantedNotification) {
      final now = DateTime.now();
      final scheduleDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      try {
        final localWord = sl<SharedPrefManager>().getDailyWord;
        if (localWord.isNullOrEmpty) return false;

        await NotificationService.showScheduleNotification(
          title: LocaleKeys.setting_time_to_learn_notification.tr(),
          body: LocaleKeys.setting_new_word_today.tr(
            args: [localWord!.first.toLowerCase(), localWord[1]],
          ).fixBreakLine,
          payload: 'payload',
          scheduleDate: scheduleDate,
        );
        return true;
      } catch (e) {
        Navigators().showMessage(e.toString(), type: MessageType.error);
      }
    } else {
      Navigators().showMessage(
        LocaleKeys.setting_noti_permission_not_allow.tr(),
        type: MessageType.error,
      );
    }
    return false;
  }

  Future<void> cancelScheduleNotification() async {
    await NotificationService.cancelNotification();
    sl<SharedPrefManager>().removeScheduleNotiTime();
  }
}
