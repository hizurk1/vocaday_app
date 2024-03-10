import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../config/app_logger.dart';
import '../constants/app_const.dart';
import '../translations/translations.dart';
import 'navigation.dart';

class NotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static const MethodChannel _methodChannel =
      MethodChannel(AppStringConst.notificationMethodChannel);

  static Future<void> initialize({bool initSchedule = false}) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _configureLocalTimeZone();
    await _notificationsPlugin.initialize(
      settings,
      // onDidReceiveBackgroundNotificationResponse: (response) {},
      // onDidReceiveNotificationResponse: (response) {},
    );
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneName =
          await _methodChannel.invokeMethod<String>('getLocalTimeZone');
      if (timeZoneName != null) {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      }
      logger.i("Local timezone: ${tz.local}");
    } on PlatformException catch (e) {
      logger.e(e.message, error: e.details);
    }
  }

  static get _notificationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'vocaday-reminder',
          'Vocabulary Reminder',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    required dynamic payload,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
    );
  }

  static Future showScheduleNotification({
    int id = 0,
    required String title,
    required String body,
    required dynamic payload,
    required DateTime scheduleDate,
  }) async {
    try {
      final scheduleDaily = _scheduleDaily(scheduleDate);
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduleDaily,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      logger.d("Schedule notification: $scheduleDaily");
    } on UnimplementedError catch (e) {
      logger.e(e.message, stackTrace: e.stackTrace);
    }
  }

  static tz.TZDateTime _scheduleDaily(DateTime date) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, date.year, date.month,
        date.day, date.hour, date.minute, date.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  static Future<void> cancelNotification({int id = 0}) async {
    Navigators().showMessage(
      LocaleKeys.setting_cancel_all_noti.tr(),
      type: MessageType.success,
    );
    await _notificationsPlugin.cancel(id);
  }
}
