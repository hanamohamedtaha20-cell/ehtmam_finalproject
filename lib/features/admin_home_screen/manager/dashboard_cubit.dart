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
    if (isClosed) return;
    try {
      emit(DashboardLoading());

      final activities =
      await repository.getActivities();

      final quickActions =
      await repository.getQuickActions();

      if (!isClosed) {
        emit(
          DashboardLoaded(
            activities: activities,
            quickActions: quickActions,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          DashboardError(
            e.toString(),
          ),
        );
      }
    }
  }
}
