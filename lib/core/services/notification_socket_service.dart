import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import '../network/api_constants.dart';
import 'local_notification_service.dart';

/// Singleton that maintains a Socket.IO connection for real-time push
/// notifications. Works while the app is open or in the background.
/// Terminated-state delivery requires FCM (not available in this project).
class NotificationSocketService {
  NotificationSocketService._();
  static final NotificationSocketService instance =
      NotificationSocketService._();

  sio.Socket? _socket;
  bool get isConnected => _socket?.connected ?? false;

  /// Connect to the backend and start listening for notification events.
  /// Safe to call multiple times — no-ops if already connected.
  void connect(String token) {
    if (token.isEmpty || token == 'admin_token') return;
    if (isConnected) return;

    debugPrint('NOTIFICATION_SOCKET_CONNECTING: $baseUrl');

    final socket = sio.io(
      baseUrl,
      sio.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'Bearer $token'})
          .disableAutoConnect()
          .build(),
    );
    _socket = socket;

    socket.onConnect((_) {
      debugPrint('NOTIFICATION_SOCKET_CONNECTED: ${socket.id}');
    });

    // Listen on all common notification event names the backend may emit.
    for (final event in [
      'notification',
      'new_notification',
      'push_notification',
    ]) {
      socket.on(event, _handleEvent);
    }

    socket.onDisconnect((_) => debugPrint('NOTIFICATION_SOCKET_DISCONNECTED'));
    socket.onConnectError(
        (e) => debugPrint('NOTIFICATION_SOCKET_CONNECT_ERROR: $e'));
    socket.onError((e) => debugPrint('NOTIFICATION_SOCKET_ERROR: $e'));

    socket.connect();
  }

  void _handleEvent(dynamic raw) {
    final Map<String, dynamic> data;
    if (raw is Map<String, dynamic>) {
      data = raw;
    } else if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else {
      debugPrint('NOTIFICATION_SOCKET_UNKNOWN_PAYLOAD: $raw');
      return;
    }

    final title = data['title']?.toString() ?? 'Ehtemam';
    final body = data['message']?.toString() ??
        data['body']?.toString() ??
        data['content']?.toString() ??
        '';
    final type = data['type']?.toString() ?? 'general';

    debugPrint('NOTIFICATION_RECEIVED: $title');
    debugPrint('NOTIFICATION_BODY: $body');

    LocalNotificationService.showNotification(
      title: title,
      body: body,
      payload: type,
    );
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    debugPrint('NOTIFICATION_SOCKET_DISPOSED');
  }
}
