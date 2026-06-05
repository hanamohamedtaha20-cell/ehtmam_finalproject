import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';

abstract class CaregiverState {}

class CaregiverInitial extends CaregiverState {}

class CaregiverLoaded extends CaregiverState {
  final CaregiverModel profile;
  CaregiverLoaded({required this.profile});
}