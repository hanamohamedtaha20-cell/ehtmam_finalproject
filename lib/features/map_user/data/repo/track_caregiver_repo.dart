import 'package:dio/dio.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/caregiver_location_model.dart';

class TrackCaregiverRepo {
  final ApiService _api;
  TrackCaregiverRepo([ApiService? api]) : _api = api ?? ApiService();

  Future<CaregiverLocationModel> getCaregiverLocation(String bookingId) async {
    try {
      final response = await _api.getCaregiverLocation(bookingId);

      // 200 response but backend returned {status: fail, data: null}
      final raw = response['data'];
      if (raw is! Map<String, dynamic>) {
        final msg = response['message']?.toString() ?? 'No location data';
        throw Exception('no_location: $msg');
      }

      return CaregiverLocationModel.fromJson(raw);
    } on DioException catch (e) {
      // 404 / 400 — body contains the backend message
      final body = e.response?.data;
      if (body is Map) {
        final msg = body['message']?.toString() ?? '';
        if (msg.isNotEmpty) throw Exception('no_location: $msg');
      }
      rethrow;
    }
  }
}
