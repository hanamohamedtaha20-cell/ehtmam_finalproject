import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/complaint_model.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit() : super(const ComplaintsState());

  Future<void> getComplaints() async {
    emit(state.copyWith(status: ComplaintsStatus.loading));

    try {
      // TODO: Replace this static list with API later
      final complaints = [
        ComplaintModel(
          id: '1',
          title: 'Poor service quality and unprofessional behavior',
          category: 'Service Quality',
          status: 'pending',
          fromName: 'Eman hani',
          fromRole: 'user',
          againstName: 'Johny Gerges',
          againstRole: 'provider',
          date: '2026-03-10',
          description:
          'The caregiver arrived 2 hours late and didn’t follow the care instructions provided.',
        ),
        ComplaintModel(
          id: '2',
          title: 'Inability to Handle Emergencies',
          category: 'Poor Management',
          status: 'pending',
          fromName: 'Sarah’s Care Services',
          fromRole: 'provider',
          againstName: 'Omar essam',
          againstRole: 'user',
          date: '2026-03-08',
          description:
          'The service provider reported difficulty handling an urgent emergency situation during the care session.',
        ),
        ComplaintModel(
          id: '3',
          title: 'Last minute cancellation without valid reason',
          category: 'Cancellation',
          status: 'resolved',
          fromName: 'ahmed ashraf',
          fromRole: 'caregiver',
          againstName: 'fatma adel',
          againstRole: 'user',
          date: '2026-03-05',
          description:
          'The booking was cancelled at the last minute without providing a valid reason.',
        ),
      ];

      emit(
        state.copyWith(
          status: ComplaintsStatus.success,
          complaints: complaints,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ComplaintsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}