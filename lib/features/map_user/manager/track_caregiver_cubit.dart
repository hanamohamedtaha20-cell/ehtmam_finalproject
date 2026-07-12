import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_service.dart';
import '../../../core/services/location_socket_service.dart';
import '../data/model/caregiver_location_model.dart';
import '../data/repo/track_caregiver_repo.dart';
import 'track_caregiver_state.dart';

class TrackCaregiverCubit extends Cubit<TrackCaregiverState> {
  // Kept for constructor compatibility with TrackCaregiverScreen.
  // REST polling has been removed -- tracking is socket-only.
  // ignore: unused_field
  final TrackCaregiverRepo _repo;
  final LocationSocketService _socket = LocationSocketService();
  final ApiService _api = ApiService();

  CaregiverLocationModel? _lastKnown;
  bool _started = false;
  Timer? _loadingTimeout;

  TrackCaregiverCubit(this._repo) : super(TrackCaregiverInitial());

  static const _waitingMsg =
      'Tracking has not started yet. Please wait until the caregiver starts sharing location.';

  /// Call once from didChangeDependencies.
  Future<void> startTracking(String bookingId) async {
    if (isClosed || _started) return;
    _started = true;

    // Q: bookingId is correct?
    debugPrint('[Track][DEBUG] ===== START TRACKING =====');
    debugPrint('[Track][DEBUG] bookingId: "$bookingId"');
    debugPrint('[Track][DEBUG] bookingId.length: ${bookingId.length}');
    debugPrint('[Track][DEBUG] bookingId.isEmpty: ${bookingId.isEmpty}');
    // MongoDB _id is always 24 hex chars
    if (bookingId.length != 24) {
      debugPrint('[Track][DEBUG] WARNING: bookingId is not 24 chars -- may not be a MongoDB _id');
    }

    if (!isClosed) emit(TrackCaregiverLoading());

    await _checkBookingStatus(bookingId);
    await _connectSocket(bookingId);
  }

  // Q: caregiver did check-in first?
  // Fetches the booking to confirm check-in status BEFORE connecting the socket.
  // Backend rejects location_update when isTrackingActive is false.
  Future<void> _checkBookingStatus(String bookingId) async {
    if (bookingId.isEmpty) return;
    debugPrint('[Track][DEBUG] Checking booking check-in status...');
    try {
      final res = await _api.getBookingById(bookingId);
      final raw = res['data'];
      Map<String, dynamic>? data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is List && raw.isNotEmpty) {
        data = raw.first as Map<String, dynamic>;
      }

      if (data == null) {
        debugPrint('[Track][DEBUG] Could not parse booking data from response');
        return;
      }

      final status = (data['bookingStatus'] ?? data['status'] ?? '').toString();
      final isTracking = data['isTrackingActive'] ?? data['trackingActive'] ?? false;
      final checkInTime = data['checkInTime'] ??
          data['check_in_time'] ??
          data['checkinTime'];
      final isCheckedIn =
          checkInTime != null || status.toUpperCase() == 'IN_PROGRESS';

      debugPrint('[Track][DEBUG] bookingStatus: "$status"');
      debugPrint('[Track][DEBUG] isTrackingActive: $isTracking');
      debugPrint('[Track][DEBUG] checkInTime: $checkInTime');
      debugPrint('[Track][DEBUG] isCheckedIn (derived): $isCheckedIn');

      if (!isCheckedIn && isTracking == false) {
        debugPrint('[Track][DEBUG] CAREGIVER HAS NOT CHECKED IN');
        debugPrint('[Track][DEBUG] Backend will reject location_update until check-in');
      } else {
        debugPrint('[Track][DEBUG] Caregiver check-in confirmed -- tracking should work');
      }
    } catch (e) {
      debugPrint('[Track][DEBUG] booking status check error: $e');
    }
  }

  Future<void> _connectSocket(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Q: token is sent in socket auth?
    final tokenStatus = token.isEmpty
        ? 'EMPTY -- socket auth will fail!'
        : 'present (${token.length} chars)';
    debugPrint('[Track][DEBUG] token from SharedPreferences: $tokenStatus');

    void handleLocation(Map<String, dynamic> data) {
      if (isClosed) return;
      debugPrint('[Track][DEBUG] handleLocation called: $data');

      final lat = (data['lat'] as num?)?.toDouble();
      final lng = (data['lng'] as num?)?.toDouble();
      debugPrint('[Track][DEBUG] parsed lat=$lat  lng=$lng');

      if (lat == null || lng == null) {
        debugPrint('[Track][DEBUG] WARNING: lat or lng is null');
        debugPrint('[Track][DEBUG] Check backend sends "lat"/"lng" not "latitude"/"longitude"');
        debugPrint('[Track][DEBUG] Raw payload keys: ${data.keys.toList()}');
        return;
      }

      final updated = CaregiverLocationModel(
        latitude: lat,
        longitude: lng,
        lastUpdated: DateTime.now().toIso8601String(),
      );
      _lastKnown = updated;
      if (!isClosed) {
        emit(TrackCaregiverLoaded(updated));
        debugPrint('[Track][DEBUG] MAP MARKER UPDATED: lat=$lat  lng=$lng');
      }
    }

    // Q: user listens to location_changed / current_location?
    debugPrint('[Track][DEBUG] Registering listener: location_changed');
    _socket.onLocationChanged(handleLocation);
    debugPrint('[Track][DEBUG] Registering listener: current_location');
    _socket.onCurrentLocation(handleLocation);
    debugPrint('[Track][DEBUG] Both listeners registered -- calling socket.connect()');

    // Safety net: stop the loading spinner after 15 s with no location data.
    _loadingTimeout = Timer(const Duration(seconds: 15), () {
      if (!isClosed && state is TrackCaregiverLoading) {
        debugPrint('[Track][DEBUG] 15s timeout -- no location received yet');
        emit(TrackCaregiverError(_waitingMsg, lastKnown: _lastKnown));
      }
    });

    _socket.connect(
      token: token,
      bookingId: bookingId,
      onConnected: () {
        // Q: join_booking callback success?
        debugPrint('[Track][DEBUG] onConnected fired -- join_booking was emitted');
        debugPrint('[Track][DEBUG] Waiting for current_location or location_changed...');
        _loadingTimeout?.cancel();
        if (!isClosed && state is TrackCaregiverLoading) {
          emit(TrackCaregiverError(_waitingMsg, lastKnown: _lastKnown));
        }
      },
      onConnectError: (message) {
        debugPrint('[Track][DEBUG] onConnectError: $message');
        _loadingTimeout?.cancel();
        if (isClosed) return;
        final isBlocked = message.toLowerCase().contains('blocked');
        final display = isBlocked
            ? 'Your account has been blocked. Please contact support.'
            : message;
        emit(TrackCaregiverError(display, lastKnown: _lastKnown));
      },
    );
  }

  void stopTracking() {
    _loadingTimeout?.cancel();
    _socket.off('location_changed');
    _socket.off('current_location');
    _socket.disconnect();
  }

  @override
  Future<void> close() {
    stopTracking();
    return super.close();
  }
}
