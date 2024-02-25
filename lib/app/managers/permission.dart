import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> get isGrantedNotification async {
    final PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      return await Permission.notification.request().isGranted;
    }
    return true;
  }
}
