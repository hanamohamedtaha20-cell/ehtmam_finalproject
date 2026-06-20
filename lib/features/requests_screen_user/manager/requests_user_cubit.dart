import 'package:flutter/foundation.dart';
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
    debugPrint("GET REQUESTS CALLED");

    if (isClosed) return;
    emit(RequestsLoading());

    try {

      final requests =
      await repo.getRequests();

      if (!isClosed) {
        emit(
          RequestsSuccess(requests),
        );
      }

    } catch (e) {
      if (!isClosed) {
        emit(RequestsError(apiErrorMessage(e)));
      }
    }
  }
}

