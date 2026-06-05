import 'package:ehtemam_final_project/features/requests_screen_user/manager/state/requests_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/requests_repo.dart';

class RequestsCubit
    extends Cubit<RequestsState> {

  final RequestsRepo repo;

  RequestsCubit(this.repo)
      : super(RequestsInitial());

  Future<void> getRequests() async {

    emit(RequestsLoading());

    try {

      final requests =
      await repo.getRequests();

      emit(
        RequestsSuccess(requests),
      );

    } catch (e) {

      emit(
        RequestsError(
          e.toString(),
        ),
      );
    }
  }
}