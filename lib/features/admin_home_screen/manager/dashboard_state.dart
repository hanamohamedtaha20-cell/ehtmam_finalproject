import '../model/activity_model.dart';
import '../model/quick_action_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<ActivityModel> activities;
  final List<QuickActionModel> quickActions;
  final int totalUsers;
  final int totalProviders;
  final int activeBookings;

  DashboardLoaded({
    required this.activities,
    required this.quickActions,
    this.totalUsers = 0,
    this.totalProviders = 0,
    this.activeBookings = 0,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}