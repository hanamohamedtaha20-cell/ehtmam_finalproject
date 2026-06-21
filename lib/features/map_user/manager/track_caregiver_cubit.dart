import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/location_socket_service.dart';
import '../data/model/caregiver_location_model.dart';
import '../data/repo/track_caregiver_repo.dart';
import 'track_caregiver_state.dart';

class TrackCaregiverCubit extends Cubit<TrackCaregiverState> {
  // Kept for constructor compatibility with TrackCaregiverScreen.
  // REST polling has been removed â€” tracking is socket-only.
  // ignore: unused_field
  final TrackCaregiverRepo _repo;
  final LocationSocketService _socket = LocationSocketService();

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

    if (!isClosed) emit(TrackCaregiverLoading());

    debugPrint('TRACK_BOOKING_ID = $bookingId');

    await _connectSocket(bookingId);
  }

  Future<void> _connectSocket(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    void handleLocation(Map<String, dynamic> data) {
      if (isClosed) return;
      final lat = (data['lat'] as num?)?.toDouble();
      final lng = (data['lng'] as num?)?.toDouble();
      debugPrint('TRACK_LAT: $lat');
      debugPrint('TRACK_LNG: $lng');
      if (lat == null || lng == null) return;

      final updated = CaregiverLocationModel(
        latitude: lat,
        longitude: lng,
        lastUpdated: DateTime.now().toIso8601String(),
      );
      _lastKnown = updated;
      if (!isClosed) {
        emit(TrackCaregiverLoaded(updated));
        debugPrint("MAP MARKER UPDATED");
        debugPrint({"lat": lat, "lng": lng}.toString());
      }
    }

    _socket.onLocationChanged(handleLocation);
    _socket.onCurrentLocation(handleLocation);

    // Safety net: if neither connected nor errored within 15 s, stop spinning.
    _loadingTimeout = Timer(const Duration(seconds: 15), () {
      if (!isClosed && state is TrackCaregiverLoading) {
        emit(TrackCaregiverError(_waitingMsg, lastKnown: _lastKnown));
      }
    });

    _socket.connect(
      token: token,
      bookingId: bookingId,
      onConnected: () {
        _loadingTimeout?.cancel();
        if (!isClosed && state is TrackCaregiverLoading) {
          emit(TrackCaregiverError(_waitingMsg, lastKnown: _lastKnown));
        }
      },
      onConnectError: (message) {
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
