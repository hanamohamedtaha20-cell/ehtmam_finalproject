import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';

abstract class CaregiverState {}

class CaregiverInitial extends CaregiverState {}

class CaregiverLoading extends CaregiverState {}

class CaregiverLoaded extends CaregiverState {
  final CaregiverModel profile;
  CaregiverLoaded({required this.profile});
}

class CaregiverError extends CaregiverState {
  final String message;
  CaregiverError(this.message);
}
