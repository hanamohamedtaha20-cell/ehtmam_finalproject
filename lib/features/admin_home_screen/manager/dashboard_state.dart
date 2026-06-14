import '../model/activity_model.dart';
import '../model/quick_action_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<ActivityModel> activities;
  final List<QuickActionModel> quickActions;

  DashboardLoaded({
    required this.activities,
    required this.quickActions,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}