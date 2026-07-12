import 'package:flutter/foundation.dart';
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

        // national_id â€” String URL from backend
        final nationalId = caregiver['national_id']?.toString();

        // mental_health_document â€” backend returns List<String>
        // Normalise to List<String> regardless of what the backend sends
        final rawMhd =
            caregiver['mental_health_document'] ??
            caregiver['mentalHealthDocument'] ??
            caregiver['mentalHealthDoc'] ??
            caregiver['mental_document'];
        final List<String> mhdList;
        if (rawMhd is List) {
          mhdList = List<String>.from(rawMhd.map((e) => e.toString()));
        } else if (rawMhd is String && rawMhd.isNotEmpty) {
          mhdList = [rawMhd];
        } else {
          mhdList = [];
        }

        // certifications â€” List<String>
        final rawCerts = caregiver['certifications'];
        final List<String> certsList = rawCerts is List
            ? List<String>.from(rawCerts.map((e) => e.toString()))
            : [];

        // Print the full raw caregiver object so we can see EVERY key the
        // backend returns. Check this log to verify national_id is present.
        debugPrint('[PendingDocs] â”€â”€â”€ caregiver: ${caregiver['_id']} â”€â”€â”€');
        debugPrint('[PendingDocs] ALL_KEYS: ${caregiver.keys.toList()}');
        debugPrint('[PendingDocs] national_id raw: ${caregiver['national_id']}');
        debugPrint('[PendingDocs] national_id parsed: $nationalId');
        debugPrint('[PendingDocs] mental_health_document: $mhdList');
        debugPrint('[PendingDocs] certifications: $certsList');

        return {
          'id': caregiver['_id'] ?? '',
          'name': caregiver['full_name'] ?? 'Unknown',
          'type': caregiver['specialty'] ?? 'Caregiver',
          'email': caregiver['email'] ?? '',
          'phone': caregiver['phoneNumber'] ?? 'Not provided',
          'status': caregiver['status'] ?? 'Pending Approval',
          'profile_picture': caregiver['profile_picture'],
          'national_id': nationalId,           // String? URL
          'certifications': certsList,          // List<String>
          'mental_health_document': mhdList,    // List<String>
          'documents': [
            if (caregiver['profile_picture'] != null) 'Profile Picture',
            if (nationalId != null && nationalId.isNotEmpty) 'National ID',
            if (certsList.isNotEmpty) 'Certificates',
            if (mhdList.isNotEmpty) 'Mental Health Document',
          ],
        };
      }).toList();

      // Newest first — MongoDB ObjectID first 8 hex chars encode the timestamp
      providers.sort((a, b) =>
          (b['id'] as String).compareTo(a['id'] as String));

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

  Future<bool> approveProvider(String id) async {
    try {
      debugPrint('[ApproveCaregiver] caregiverId: $id');
      final response = await apiService.approveCaregiver(id);
      debugPrint('[ApproveCaregiver] statusCode: success | response: $response');
      await getPendingApprovals();
      return true;
    } catch (e) {
      debugPrint('[ApproveCaregiver] error: $e');
      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.error,
            errorMessage: 'Failed to approve caregiver. Please try again.',
          ),
        );
      }
      return false;
    }
  }

  Future<bool> rejectProvider(String id) async {
    try {
      debugPrint('[RejectCaregiver] caregiverId: $id');
      final response = await apiService.rejectCaregiver(
        id: id,
        reason:
            'The uploaded documents contain incorrect or unclear information.',
      );
      debugPrint('[RejectCaregiver] statusCode: success | response: $response');
      await getPendingApprovals();
      return true;
    } catch (e) {
      debugPrint('[RejectCaregiver] error: $e');
      if (!isClosed) {
        emit(
          state.copyWith(
            status: PendingApprovalsStatus.error,
            errorMessage: 'Failed to reject caregiver. Please try again.',
          ),
        );
      }
      return false;
    }
  }
}

