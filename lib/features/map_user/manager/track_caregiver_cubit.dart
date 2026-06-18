import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/caregiver_location_model.dart';
import '../data/repo/track_caregiver_repo.dart';
import 'track_caregiver_state.dart';

class TrackCaregiverCubit extends Cubit<TrackCaregiverState> {
  final TrackCaregiverRepo _repo;

  TrackCaregiverCubit(this._repo) : super(TrackCaregiverInitial());

  Timer? _timer;
  CaregiverLocationModel? _lastKnown;

  static const Duration _pollInterval = Duration(seconds: 7);

  /// Fetches immediately then polls every 7 seconds.
  /// Safe to call again — cancels any running timer first.
  Future<void> startTracking(String bookingId) async {
    if (isClosed) return;
    _timer?.cancel();
    emit(TrackCaregiverLoading());
    await _fetchLocation(bookingId);
    _timer = Timer.periodic(_pollInterval, (_) => _fetchLocation(bookingId));
  }

  /// Cancels the polling timer without closing the cubit.
  void stopTracking() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchLocation(String bookingId) async {
    if (isClosed) return;
    try {
      final location = await _repo.getCaregiverLocation(bookingId);
      _lastKnown = location;
      if (!isClosed) emit(TrackCaregiverLoaded(location));
    } catch (e) {
      // Keep last known location visible on transient failures
      if (!isClosed) {
        emit(TrackCaregiverError(e.toString(), lastKnown: _lastKnown));
      }
    }
  }

  /// Automatically cancels the timer when the screen is disposed.
  @override
  Future<void> close() {
    stopTracking();
    return super.close();
  }
}
