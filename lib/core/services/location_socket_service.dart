import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import '../network/api_constants.dart';

/// Single-use socket wrapper per screen.
/// Call connect() → register callbacks → disconnect().
class LocationSocketService {
  sio.Socket? _socket;

  // Stored so they can be re-registered when the socket is created in connect().
  void Function(Map<String, dynamic>)? _locationChangedCallback;
  void Function(Map<String, dynamic>)? _currentLocationCallback;

  bool get isConnected => _socket?.connected ?? false;

  /// Connects to the Socket.IO server.
  ///
  /// [token]       raw JWT — "Bearer " prefix is added automatically.
  /// [bookingId]   room to join; emitted as {"bookingId": bookingId} object.
  /// [onConnected] called AFTER join_booking is emitted.
  void connect({
    String? token,
    required String bookingId,
    void Function()? onConnected,
    void Function(String message)? onConnectError,
  }) {
    // ── Q: bookingId is correct? ──────────────────────────────────────────────
    debugPrint('[Socket][DEBUG] ========== SOCKET CONNECT CALLED ==========');
    debugPrint('[Socket][DEBUG] bookingId: "$bookingId" (length=${bookingId.length})');
    debugPrint('[Socket][DEBUG] bookingId isEmpty: ${bookingId.isEmpty}');

    if (bookingId.isEmpty) {
      debugPrint('[Socket] CONNECT_ABORTED: bookingId is empty');
      return;
    }

    if (_socket != null && !isConnected) {
      debugPrint('[Socket][DEBUG] Stale socket found — cleaning up before reconnect');
      _socket?.disconnect();
      _socket = null;
    }

    // Already connected: just join the room and return.
    if (_socket != null && isConnected) {
      debugPrint('[Socket][DEBUG] Already connected (id=${_socket?.id}) — re-joining room');
      final joinPayload = {'bookingId': bookingId};
      debugPrint('[Socket] emit join_booking (already-connected): $joinPayload');
      _socket?.emit('join_booking', joinPayload);
      onConnected?.call();
      return;
    }

    // Capture callback to outlive the connect() stack frame.
    final connectErrorCb = onConnectError;

    // ── Q: token is sent in socket auth? ─────────────────────────────────────
    final hasToken = token != null && token.isNotEmpty;
    final tokenPreview = hasToken
        ? (token.length > 20 ? '${token.substring(0, 20)}...' : token)
        : 'EMPTY';
    debugPrint('[Socket][DEBUG] token present: $hasToken — preview: $tokenPreview');
    debugPrint('[Socket][DEBUG] auth will be: ${hasToken ? '{"token": "Bearer <token>"}' : 'NONE — socket will likely be rejected'}');
    debugPrint('[Socket] Connecting to $baseUrl');

    final opts = sio.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect();

    if (hasToken) {
      opts.setAuth({'token': 'Bearer $token'});
      debugPrint('[Socket][DEBUG] auth option SET with Bearer token');
    } else {
      debugPrint('[Socket][DEBUG] WARNING: no token — connecting unauthenticated');
    }

    _socket = sio.io(baseUrl, opts.build());

    // Capture locally — never use _socket! inside callbacks to avoid null crashes.
    final socket = _socket;

    // ── Q: user listens to location_changed? / current_location? ─────────────
    // Re-register callbacks stored before connect() was called.
    final lc = _locationChangedCallback;
    if (lc != null) {
      debugPrint('[Socket][DEBUG] Re-registering listener: location_changed');
      socket?.on('location_changed',
          (raw) => _dispatch(raw, 'LOCATION_CHANGED', lc));
    } else {
      debugPrint('[Socket][DEBUG] WARNING: no location_changed callback stored yet');
    }

    final cc = _currentLocationCallback;
    if (cc != null) {
      debugPrint('[Socket][DEBUG] Re-registering listener: current_location');
      socket?.on('current_location',
          (raw) => _dispatch(raw, 'CURRENT_LOCATION', cc));
    } else {
      debugPrint('[Socket][DEBUG] WARNING: no current_location callback stored yet');
    }

    // Catch likely camelCase / singular variants so we notice if backend name differs.
    socket?.on('locationChanged',
        (raw) => debugPrint('[Socket][DEBUG] RECEIVED camelCase "locationChanged" — backend event name mismatch! raw=$raw'));
    socket?.on('location_change',
        (raw) => debugPrint('[Socket][DEBUG] RECEIVED "location_change" (singular) — backend event name mismatch! raw=$raw'));
    socket?.on('currentLocation',
        (raw) => debugPrint('[Socket][DEBUG] RECEIVED camelCase "currentLocation" — backend event name mismatch! raw=$raw'));

    // ── Q: socket connected? ─────────────────────────────────────────────────
    socket?.onConnect((_) {
      debugPrint('[Socket] ✓ CONNECTED — socket.id=${socket.id}');
      debugPrint('[Socket][DEBUG] connected: ${socket.connected}');

      // ── Q: user emits join_booking? ──────────────────────────────────────────
      if (bookingId.isNotEmpty) {
        // Backend expects object {"bookingId": "..."}, NOT a raw string.
        final joinPayload = {'bookingId': bookingId};
        debugPrint('[Socket] → emitting join_booking: $joinPayload');
        socket.emit('join_booking', joinPayload);
        debugPrint('[Socket][DEBUG] join_booking emitted — waiting for current_location or location_changed...');
      } else {
        debugPrint('[Socket] JOIN_BOOKING_SKIPPED: bookingId is empty');
        return;
      }

      onConnected?.call();
    });

    socket?.onDisconnect((_) => debugPrint('[Socket] DISCONNECTED'));

    socket?.onConnectError((err) {
      String message = 'Socket connection error';
      if (err is Map) {
        message = err['message']?.toString() ??
            err['data']?.toString() ??
            message;
      } else if (err is String) {
        message = err;
      } else if (err != null) {
        message = err.toString();
      }
      debugPrint('[Socket] ✗ CONNECT_ERROR: $message');
      debugPrint('[Socket][DEBUG] full connect_error payload: $err');
      if (message.toLowerCase().contains('blocked')) {
        debugPrint('[Socket] Account blocked — disconnecting');
        socket.disconnect();
      }
      connectErrorCb?.call(message);
    });

    socket?.on('error', (err) {
      debugPrint('[Socket] ERROR event: $err');
    });

    socket?.on('connect_timeout', (_) {
      debugPrint('[Socket][DEBUG] connect_timeout fired');
    });

    socket?.connect();
    debugPrint('[Socket][DEBUG] socket.connect() called — waiting for CONNECTED event...');
  }

  void _dispatch(
      dynamic raw, String tag, void Function(Map<String, dynamic>) cb) {
    final Map<String, dynamic> data;
    if (raw is Map<String, dynamic>) {
      data = raw;
    } else if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else {
      debugPrint('[Socket] $tag — unexpected payload type: ${raw.runtimeType} value: $raw');
      return;
    }
    debugPrint('[Socket] ✓ $tag received: $data');
    cb(data);
  }

  /// User side: live location updates from caregiver.
  void onLocationChanged(void Function(Map<String, dynamic> data) callback) {
    debugPrint('[Socket][DEBUG] onLocationChanged() registered — socket null: ${_socket == null}');
    _locationChangedCallback = callback;
    // If socket already exists (reconnect case), register immediately.
    if (_socket != null) {
      _socket?.on('location_changed',
          (raw) => _dispatch(raw, 'LOCATION_CHANGED', callback));
      debugPrint('[Socket][DEBUG] location_changed listener added to existing socket');
    }
  }

  /// User side: initial snapshot emitted by backend when joining the room.
  void onCurrentLocation(void Function(Map<String, dynamic> data) callback) {
    debugPrint('[Socket][DEBUG] onCurrentLocation() registered — socket null: ${_socket == null}');
    _currentLocationCallback = callback;
    if (_socket != null) {
      _socket?.on('current_location',
          (raw) => _dispatch(raw, 'CURRENT_LOCATION', callback));
      debugPrint('[Socket][DEBUG] current_location listener added to existing socket');
    }
  }

  /// Caregiver side: broadcast current GPS position.
  void emitLocationUpdate({
    required String bookingId,
    required double lat,
    required double lng,
  }) {
    if (!isConnected) {
      debugPrint('[Socket] NOT_CONNECTED — skipping location_update emit');
      return;
    }
    final payload = {'bookingId': bookingId, 'lat': lat, 'lng': lng};
    debugPrint('[Socket] → emit location_update: $payload');
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
