import 'package:flutter_bloc/flutter_bloc.dart';
import 'pending_approvals_state.dart';

class PendingApprovalsCubit extends Cubit<PendingApprovalsState> {
  PendingApprovalsCubit() : super(const PendingApprovalsState());

  void getPendingApprovals() {
    emit(
      state.copyWith(
        status: PendingApprovalsStatus.success,
        providers: [
          {
            'id': '1',
            'name': 'Ahmed\nMohamed',
            'type': 'Care giver',
            'email': 'ahmed.mohamed@email.com',
            'phone': '+20 123 456 7890',
            'status': 'Rejected',
            'documents': ['Profile Picture', 'National ID'],
          },
          {
            'id': '2',
            'name': 'Fatma\nHassan',
            'type': 'Caregiver',
            'email': 'fatma.hassan@careservices.com',
            'phone': '+20 111 222 3333',
            'status': 'Pending',
            'documents': ['Profile Picture', 'National ID'],
          },
        ],
      ),
    );
  }

  void approveProvider(String id) {
    final updated = state.providers.map((provider) {
      if (provider['id'] == id) {
        return {
          ...provider,
          'status': 'Approved',
        };
      }
      return provider;
    }).toList();

    emit(state.copyWith(providers: updated));
  }

  void rejectProvider(String id) {
    final updated = state.providers.map((provider) {
      if (provider['id'] == id) {
        return {
          ...provider,
          'status': 'Rejected',
        };
      }
      return provider;
    }).toList();

    emit(state.copyWith(providers: updated));
  }
}