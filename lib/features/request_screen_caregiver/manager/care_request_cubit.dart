import 'package:ehtemam_final_project/features/request_screen_caregiver/manager/state/care_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/Repository.dart';

class CareRequestsCubit extends Cubit<CareRequestsState> {
  final CareRequestsRepository repository;

  CareRequestsCubit(this.repository) : super(CareRequestsInitial());

  Future<void> getAllRequests() async {
    if (isClosed) return;
    emit(CareRequestsLoading());

    try {
      final requests = await repository.getAllRequests();
      if (!isClosed) {
        emit(CareRequestsLoaded(requests));
      }
    } catch (e) {
      if (!isClosed) {
        emit(CareRequestsError(e.toString()));
      }
    }
  }

  Future<void> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    try {
      await repository.respondToRequest(
        requestId: requestId,
        action: action,
      );
      await getAllRequests();
    } catch (e) {
      if (!isClosed) {
        emit(CareRequestsError(e.toString()));
      }
    }
  }
}
