import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/shared/services/firebase_messaging_permissions.dart';

const AndroidNotificationChannel _androidNotificationChannel =
    AndroidNotificationChannel(
      'default_channel',
      'Notifications',
      importance: Importance.max,
    );

final FlutterLocalNotificationsPlugin _backgroundLocalNotifications =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _setupLocalNotifications(_backgroundLocalNotifications);
  await _showLocalNotification(
    plugin: _backgroundLocalNotifications,
    message: message,
  );
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref);
});

class FcmService {
  bool _listenersReady = false;
  bool _localNotificationsInitialized = false;
  Future<void>? _setupInFlight;
  final Ref ref;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FcmService(this.ref);

  Future<void> ensureMessagingReady() {
    if (_listenersReady) return Future.value();
    _setupInFlight ??= _ensureMessagingReadyImpl().whenComplete(() {
      _setupInFlight = null;
    });
    return _setupInFlight!;
  }

  Future<void> _ensureMessagingReadyImpl() async {
    if (_listenersReady) return;

    final settings = await FirebaseMessagingPermissions.request();

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      debugPrint(
        'FCM permission not granted: ${settings.authorizationStatus.name}',
      );
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
    _setupListeners();
    _listenersReady = true;
  }

  /// Registers the device FCM token with the backend (safe to call after each login/session restore).
  Future<void> syncTokenWithBackend() async {
    await ensureMessagingReady();
    await _registerToken();
  }

  Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;
    _localNotificationsInitialized = true;
    await _setupLocalNotifications(_localNotifications);
  }

  Future<void> _registerToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      debugPrint('FCM device token acquired: $token');
      await sendFcmTokenToBackend(token);
      return;
    }

    debugPrint('FCM device token is null.');
  }

  Future<void> sendFcmTokenToBackend(String fcmToken) async {
    final authProvider = ref.read(logtoAuthProvider);
    final email = ref.read(authNotifierProvider).valueOrNull?.user?.email;
    final backendApiUrl = dotenv.env['BACKEND_API_URL'];

    if (email == null || email.isEmpty) {
      debugPrint('FCM token not sent: user email is unavailable.');
      return;
    }

    if (backendApiUrl == null || backendApiUrl.isEmpty) {
      debugPrint('FCM token not sent: BACKEND_API_URL is missing.');
      return;
    }

    try {
      await authProvider.dioClient.post(
        _buildBackendUrl(backendApiUrl, 'user/tokens'),
        data: {
          'email': email,
          'token': fcmToken,
        },
      );
      debugPrint('FCM token sent to backend successfully.');
    } on DioException catch (e) {
      debugPrint('Error sending FCM token to backend: ${e.message}');
      if (e.response != null) {
        debugPrint('Backend response: ${e.response?.data}');
      }
    } catch (e) {
      debugPrint('An unexpected error occurred while sending FCM token: $e');
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
    print(message.data);
    _showLocalNotification(
      plugin: _localNotifications,
      message: message,
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    debugPrint('User tapped on notification: ${message.messageId}');
  }
}

String _buildBackendUrl(String baseUrl, String path) {
  final normalizedBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  return '$normalizedBaseUrl$path';
}

Future<void> _setupLocalNotifications(
  FlutterLocalNotificationsPlugin plugin,
) async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await plugin.initialize(settings);

  await plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_androidNotificationChannel);
}

Future<void> _showLocalNotification({
  required FlutterLocalNotificationsPlugin plugin,
  required RemoteMessage message,
}) async {
  final title = message.notification?.title ?? message.data['title'] as String?;
  final body = message.notification?.body ?? message.data['body'] as String?;
  final senderName = message.data['senderName'] as String?; // add this

  final displayTitle = title ?? (senderName != null ? '$senderName sent a ride request' : 'New ride request');
  final displayBody = body ?? '';

  if (title == null && body == null) {
    return;
  }

  await plugin.show(
    message.hashCode,
    title ?? 'Ride request',
    body ?? '',
    NotificationDetails(
      android: AndroidNotificationDetails(
        _androidNotificationChannel.id,
        _androidNotificationChannel.name,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    payload: message.data.isNotEmpty ? message.data.toString() : null,
  );
}