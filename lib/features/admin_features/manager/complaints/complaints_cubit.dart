import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../data/complaint_model.dart';
import '../../data/complaint_details_model.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ApiService _api;

  ComplaintsCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(const ComplaintsState());

  Future<void> getComplaints() async {
    // These logs fire before anything else — guaranteed to appear.
    debugPrint('### MANAGE_COMPLAINTS_SCREEN_OPENED ###');
    debugPrint('### GET_COMPLAINTS_CALLED ###');
    debugPrint('GET COMPLAINTS URL: /complaints');

    if (isClosed) return;
    emit(state.copyWith(status: ComplaintsStatus.loading));

    try {
      final response = await _api.getComplaints();

      debugPrint('GET COMPLAINTS RESPONSE: $response');

      // Response shape: { "data": { "complaints": [...] } }
      final dataMap = response['data'];
      List<dynamic> raw = [];
      if (dataMap is Map) {
        raw = (dataMap['complaints'] as List?) ?? [];
      } else if (dataMap is List) {
        raw = dataMap;
      }

      final complaints = raw
          .whereType<Map>()
          .map((item) =>
              ComplaintModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      debugPrint('COMPLAINTS COUNT: ${complaints.length}');

      if (!isClosed) {
        emit(state.copyWith(
          status: ComplaintsStatus.success,
          complaints: complaints,
        ));
      }
    } catch (e, st) {
      debugPrint('GET COMPLAINTS ERROR: $e');
      debugPrint('GET COMPLAINTS STACKTRACE: $st');
      if (!isClosed) {
        emit(state.copyWith(
          status: ComplaintsStatus.error,
          errorMessage: 'Failed to load complaints.',
        ));
      }
    }
  }

  Future<void> getComplaintDetails(String complaintId) async {
    debugPrint('GET COMPLAINT DETAILS URL: /complaints/$complaintId');

    if (isClosed) return;
    emit(state.copyWith(detailsStatus: DetailsStatus.loading));

    try {
      final response = await _api.getComplaintDetails(complaintId);

      debugPrint('GET COMPLAINT DETAILS RESPONSE: $response');

      final details = ComplaintDetailsModel.fromJson(response);

      if (!isClosed) {
        emit(state.copyWith(
          detailsStatus: DetailsStatus.loaded,
          details: details,
        ));
      }
    } catch (e, st) {
      debugPrint('GET COMPLAINT DETAILS ERROR: $e');
      debugPrint('GET COMPLAINT DETAILS STACKTRACE: $st');
      if (!isClosed) {
        emit(state.copyWith(
          detailsStatus: DetailsStatus.error,
          detailsErrorMessage: 'Failed to load complaint details.',
        ));
      }
    }
  }
}
