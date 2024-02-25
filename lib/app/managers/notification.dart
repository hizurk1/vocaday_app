import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

import '../../config/app_logger.dart';
import 'navigation.dart';

class NotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  // final StreamController<ReceivedNotification>
  //     didReceiveLocalNotificationStream =
  //     StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static Future initialize({bool initSchedule = false}) async {
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

    await _notificationsPlugin.initialize(
      settings,
      // onDidReceiveBackgroundNotificationResponse: (response) {},
      // onDidReceiveNotificationResponse: (response) {},
    );
  }

  static get _notificationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
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
    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    tz.setLocalLocation(location);
    final scheduleDaily = _scheduleDaily(scheduleDate, location);
    logger.w(scheduleDaily);

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
  }

  static tz.TZDateTime _scheduleDaily(DateTime date, Location location) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        date.hour, date.minute, date.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  static Future<void> cancelNotification({int id = 0}) async {
    Navigators().showMessage(
      "Canceled all notitifications.",
      type: MessageType.success,
    );
    await _notificationsPlugin.cancel(id);
  }
}
