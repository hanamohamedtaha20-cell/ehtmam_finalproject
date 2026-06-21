import 'package:ehtemam_final_project/features/admin_home_screen/manager/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/repo/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository) : super(DashboardInitial());

  Future<void> getDashboardData() async {
    if (isClosed) return;
    emit(DashboardLoading());
    try {
      // Start all three fetches concurrently before awaiting any.
      final activitiesFuture   = repository.getActivities();
      final quickActionsFuture = repository.getQuickActions();
      final statsFuture        = repository.getStats();

      final activities   = await activitiesFuture;
      final quickActions = await quickActionsFuture;
      final stats        = await statsFuture;

      if (!isClosed) {
        emit(DashboardLoaded(
          activities:     activities,
          quickActions:   quickActions,
          totalUsers:     stats['totalUsers']     ?? 0,
          totalProviders: stats['totalProviders'] ?? 0,
          activeBookings: stats['activeBookings'] ?? 0,
        ));
      }
    } catch (e) {
      if (!isClosed) emit(DashboardError(e.toString()));
    }
  }
}
