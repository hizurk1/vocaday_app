import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestPermission() async {
    final statuses = await Future.wait([
      Permission.notification.status,
      Permission.scheduleExactAlarm.status,
    ]);
    if (!statuses.every((e) => e.isGranted)) {
      await [
        Permission.notification,
        Permission.scheduleExactAlarm,
      ].request();
    }
  }

  static Future<bool> get isGrantedNotification async {
    final notificationStatus = await Permission.notification.status;
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;

    if (notificationStatus.isGranted && exactAlarmStatus.isGranted) {
      return true;
    }

    final notiReq = await Permission.notification.request().isGranted;
    final exactAlarmReq =
        await Permission.scheduleExactAlarm.request().isGranted;

    return notiReq && exactAlarmReq;
  }
}
