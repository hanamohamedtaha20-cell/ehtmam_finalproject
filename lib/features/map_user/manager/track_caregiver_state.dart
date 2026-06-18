import '../data/model/caregiver_location_model.dart';

abstract class TrackCaregiverState {}

class TrackCaregiverInitial extends TrackCaregiverState {}

class TrackCaregiverLoading extends TrackCaregiverState {}

class TrackCaregiverLoaded extends TrackCaregiverState {
  final CaregiverLocationModel location;
  TrackCaregiverLoaded(this.location);
}

/// Error state retains the last known location so the map marker
/// doesn't disappear on a transient network failure.
class TrackCaregiverError extends TrackCaregiverState {
  final String message;
  final CaregiverLocationModel? lastKnown;
  TrackCaregiverError(this.message, {this.lastKnown});
}
