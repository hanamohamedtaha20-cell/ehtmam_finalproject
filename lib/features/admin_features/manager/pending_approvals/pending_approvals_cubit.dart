import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import 'pending_approvals_state.dart';

class PendingApprovalsCubit extends Cubit<PendingApprovalsState> {
  final ApiService apiService;

  PendingApprovalsCubit({
    ApiService? apiService,
  })  : apiService = apiService ?? ApiService(),
        super(const PendingApprovalsState());

  Future<void> getPendingApprovals() async {
    if (isClosed) return;
    emit(state.copyWith(status: PendingApprovalsStatus.loading));

    try {
      final response = await apiService.getPendingCaregivers();

      final caregivers =
          response['data']?['caregivers'] as List<dynamic>? ?? [];

      final providers = caregivers.map((item) {
        final caregiver = Map<String, dynamic>.from(item as Map);

        return {
          'id': caregiver['_id'] ?? '',
          'name': caregiver['full_name'] ?? 'Unknown',
          'type': caregiver['specialty'] ?? 'Caregiver',
          'email': caregiver['email'] ?? '',
          'phone': caregiver['phoneNumber'] ?? 'Not provided',
          'status': caregiver['status'] ?? 'Pending Approval',
          'profile_picture': caregiver['profile_picture'],
          'certifications': caregiver['certifications'] ?? [],
          'verification_documents': caregiver['verification_documents'] ?? [],
          'documents': [
            if (caregiver['profile_picture'] != null) 'Profile Picture',
            if ((caregiver['verification_documents'] as List?)?.isNotEmpty ?? false)
              'National ID',
            if ((caregiver['certifications'] as List?)?.isNotEmpty ?? false)
              'Certificates',
          ],
        };
      }).toList();

      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.success,
            providers: providers,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> approveProvider(String id) async {
    try {
      await apiService.approveCaregiver(id);

      await getPendingApprovals();
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.error,
            errorMessage: 'Approve failed: $e',
          ),
        );
      }
    }
  }

  Future<void> rejectProvider(String id) async {
    try {
      await apiService.rejectCaregiver(
        id: id,
        reason: 'Documents are invalid',
      );

      final updated =
      state.providers.where((provider) => provider['id'] != id).toList();

      if (!isClosed) {
        emit(state.copyWith(providers: updated));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.error,
            errorMessage: 'Reject failed: $e',
          ),
        );
      }
    }
  }
}
