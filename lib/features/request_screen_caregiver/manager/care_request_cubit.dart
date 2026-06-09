import 'package:ehtemam_final_project/features/request_screen_caregiver/manager/state/care_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/Repository.dart';


class CareRequestsCubit
    extends Cubit<CareRequestsState> {

  final CareRequestsRepository repository;

  CareRequestsCubit(
      this.repository,
      ) : super(
    CareRequestsInitial(),
  );

  Future<void> getRequests() async {
    emit(CareRequestsLoading());

    try {
      final requests =
      await repository
          .getAvailableRequests();

      emit(
        CareRequestsLoaded(
          requests,
        ),
      );
    } catch (e) {
      emit(
        CareRequestsError(
          e.toString(),
        ),
      );
    }
  }
}