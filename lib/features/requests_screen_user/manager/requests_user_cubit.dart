import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/manager/state/requests_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/requests_repo.dart';

class RequestsCubit
    extends Cubit<RequestsState> {

  final RequestsRepo repo;

  RequestsCubit(this.repo)
      : super(RequestsInitial());

  Future<void> getRequests() async {
    print("GET REQUESTS CALLED");

    emit(RequestsLoading());

    try {

      final requests =
      await repo.getRequests();

      emit(
        RequestsSuccess(requests),
      );

    } catch (e) {
      emit(RequestsError(apiErrorMessage(e)));
    }
  }
}