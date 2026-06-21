import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'ehtemam_high_channel';
  static const _channelName = 'Ehtemam Notifications';
  static const _channelDesc = 'Important notifications for Ehtemam app';

  /// Set before calling [init] to handle notification taps.
  /// Receives the payload string (notification type) passed when showing.
  static void Function(String? payload)? onNotificationTap;

  static Future<void> init() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('NOTIFICATION_TAP: ${details.payload}');
        onNotificationTap?.call(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    debugPrint('LOCAL_NOTIFICATION_SERVICE: initialized');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('NOTIFICATION_RECEIVED: $title');
    debugPrint('NOTIFICATION_BODY: $body');

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }
}

@pragma('vm:entry-point')
void _onBackgroundTap(NotificationResponse details) {
  debugPrint('NOTIFICATION_BACKGROUND_TAP: ${details.payload}');
}
