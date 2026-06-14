import 'package:ehtemam_final_project/features/admin_home_screen/manager/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/repo/dashboard_repository.dart';

class DashboardCubit
    extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository)
      : super(DashboardInitial());

  Future<void>
  getDashboardData() async {
    try {
      emit(DashboardLoading());

      final activities =
      await repository.getActivities();

      final quickActions =
      await repository.getQuickActions();

      emit(
        DashboardLoaded(
          activities: activities,
          quickActions: quickActions,
        ),
      );
    } catch (e) {
      emit(
        DashboardError(
          e.toString(),
        ),
      );
    }
  }
}