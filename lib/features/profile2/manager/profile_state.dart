import 'package:ehtemam_final_project/features/profile2/data/model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final int totalRequests;
  final int completed;
  final double rating;

  ProfileLoaded({
    required this.user,
    required this.totalRequests,
    required this.completed,
    required this.rating,
  });
}