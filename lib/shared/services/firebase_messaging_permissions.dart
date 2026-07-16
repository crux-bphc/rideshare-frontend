import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase allows only one in-flight [requestPermission] call at a time.
class FirebaseMessagingPermissions {
  static Future<NotificationSettings>? _inFlight;

  static Future<NotificationSettings> request() {
    _inFlight ??= FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
        )
        .whenComplete(() {
          _inFlight = null;
        });
    return _inFlight!;
  }
}
