import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import '../network/api_constants.dart';

/// Single-use socket wrapper per screen.
/// Call connect() â†’ emitLocationUpdate() / onLocationChanged() â†’ disconnect().
class LocationSocketService {
  sio.Socket? _socket;

  // Stored so they can be re-registered when the socket is created in connect().
  void Function(Map<String, dynamic>)? _locationChangedCallback;
  void Function(Map<String, dynamic>)? _currentLocationCallback;

  bool get isConnected => _socket?.connected ?? false;

  /// Connects to the Socket.IO server.
  ///
  /// [token]       raw JWT â€” "Bearer " prefix is added automatically.
  /// [bookingId]   room to join; emitted as a raw string inside onConnect.
  /// [onConnected] called AFTER join_booking is emitted.
  void connect({
    String? token,
    required String bookingId,
    void Function()? onConnected,
  }) {
    debugPrint('SOCKET_BOOKING_ID: $bookingId');

    if (bookingId.isEmpty) {
      debugPrint('SOCKET_CONNECT_ABORTED: bookingId is empty');
      return;
    }

    if (_socket != null && !isConnected) {
      _socket?.disconnect();
      _socket = null;
    }

    if (_socket != null && isConnected) {
      debugPrint('[Socket] Already connected â€” joining: $bookingId');
      debugPrint("JOIN BOOKING");
      debugPrint({"bookingId": bookingId}.toString());
      _socket?.emit('join_booking', bookingId);
      onConnected?.call();
      return;
    }

    final tokenPreview = (token != null && token.length > 20)
        ? '${token.substring(0, 20)}...'
        : (token?.isNotEmpty == true ? token : 'EMPTY');
    debugPrint('SOCKET_CONNECTING: url=$baseUrl token=$tokenPreview');

    final opts = sio.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect();

    if (token != null && token.isNotEmpty) {
      opts.setAuth({'token': 'Bearer $token'});
    }

    _socket = sio.io(baseUrl, opts.build());

    // Capture locally â€” never use _socket! inside callbacks to avoid null crashes.
    final socket = _socket;

    // Re-register any callbacks that were stored before connect() was called.
    final lc = _locationChangedCallback;
    if (lc != null) {
      socket?.on('location_changed',
          (raw) => _dispatch(raw, 'LOCATION CHANGED', lc));
    }
    final cc = _currentLocationCallback;
    if (cc != null) {
      socket?.on('current_location',
          (raw) => _dispatch(raw, 'CURRENT LOCATION', cc));
    }

    socket?.onConnect((_) {
      debugPrint("CLIENT SOCKET CONNECTED");
      debugPrint('[Socket] id: ${socket.id}');

      if (bookingId.isNotEmpty) {
        debugPrint("JOIN BOOKING");
        debugPrint({"bookingId": bookingId}.toString());
        socket.emit('join_booking', bookingId);
      } else {
        debugPrint('JOIN_BOOKING_FAILED: bookingId is empty');
        return;
      }

      onConnected?.call();
    });

    socket?.onDisconnect((_) => debugPrint('SOCKET_DISCONNECTED'));
    socket?.onConnectError((err) {
      debugPrint("CLIENT SOCKET ERROR");
      debugPrint(err);
    });
    socket?.onError((err) {
      debugPrint("SOCKET ERROR");
      debugPrint(err);
    });

    socket?.connect();
  }

  void _dispatch(
      dynamic raw, String tag, void Function(Map<String, dynamic>) cb) {
    final Map<String, dynamic> data;
    if (raw is Map<String, dynamic>) {
      data = raw;
    } else if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else {
      debugPrint('[Socket] $tag payload has unexpected type: ${raw.runtimeType}');
      return;
    }
    debugPrint(tag.toString());
    debugPrint(data.toString());
    cb(data);
  }

  /// User side: live location updates from caregiver.
  void onLocationChanged(void Function(Map<String, dynamic> data) callback) {
    _locationChangedCallback = callback;
    _socket?.on('location_changed',
        (raw) => _dispatch(raw, 'LOCATION CHANGED', callback));
  }

  /// User side: initial snapshot emitted by backend when joining the room.
  void onCurrentLocation(void Function(Map<String, dynamic> data) callback) {
    _currentLocationCallback = callback;
    _socket?.on('current_location',
        (raw) => _dispatch(raw, 'CURRENT LOCATION', callback));
  }

  /// Caregiver side: broadcast current GPS position.
  void emitLocationUpdate({
    required String bookingId,
    required double lat,
    required double lng,
  }) {
    if (!isConnected) {
      debugPrint('[Socket] Not connected â€” skipping location_update emit');
      return;
    }
    final payload = {'bookingId': bookingId, 'lat': lat, 'lng': lng};
    debugPrint('LOCATION_UPDATE_EMITTED: $payload');
    _socket?.emit('location_update', payload);
  }

  void off(String event) => _socket?.off(event);

  void disconnect() {
    _locationChangedCallback = null;
    _currentLocationCallback = null;
    _socket?.disconnect();
    _socket = null;
    debugPrint('[Socket] Disconnected and cleaned up');
  }
}
