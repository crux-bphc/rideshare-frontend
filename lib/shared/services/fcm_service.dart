import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref);
});

class FcmService {
  bool _initialized = false;
  final Ref ref;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'default_channel',
        'Notifications',
        importance: Importance.max,
      );

  FcmService(this.ref);

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _initializeLocalNotifications();

    await _registerToken();

    _setupListeners();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _registerToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await sendFcmTokenToBackend(token);
    }
  }

  Future<void> sendFcmTokenToBackend(String fcmToken) async {
    final authProvider = ref.read(logtoAuthProvider);
    final idToken = await authProvider.idToken;

    if (idToken == null) {
      print('Error: ID Token not available. Cannot send FCM token.');
      return;
    }

    try {
      await authProvider.dioClient.post(
        '/user/tokens',
        data: {'token': fcmToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );
      print('FCM token sent to backend successfully.');
    } on DioException catch (e) {
      print('Error sending FCM token to backend: ${e.message}');
      if (e.response != null) {
        print('Backend response: ${e.response?.data}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageTap(message);
      }
    });

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await sendFcmTokenToBackend(newToken);
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    print('User tapped on notification: ${message.messageId}');
  }
}
