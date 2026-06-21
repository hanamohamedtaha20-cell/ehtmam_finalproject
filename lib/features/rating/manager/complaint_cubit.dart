import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/complaint_model.dart';
import '../data/repo/complaint_repo.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository _repo;

  ComplaintCubit({ComplaintRepository? repo})
      : _repo = repo ?? ComplaintRepository(),
        super(ComplaintInitial());

  Future<void> submitComplaint({
    required String bookingId,
    required String subject,
    required String message,
    required String complaintCategory,
  }) async {
    if (isClosed) return;
    emit(ComplaintSubmitting());
    try {
      final result = await _repo.submitComplaint(
        ComplaintRequest(
          bookingId:         bookingId,
          subject:           subject,
          message:           message,
          complaintCategory: complaintCategory,
        ),
      );
      if (!isClosed) emit(ComplaintSuccess(result));
    } catch (e) {
      if (!isClosed) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        emit(ComplaintError(msg));
      }
    }
  }
}
