import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/caregiver_location_model.dart';

class TrackCaregiverRepo {
  final ApiService _api = ApiService();

  /// Calls GET /booking/{bookingId}/location and returns a typed model.
  /// Throws on network/parse error so the cubit can surface it.
  Future<CaregiverLocationModel> getCaregiverLocation(String bookingId) async {
    final response = await _api.getCaregiverLocation(bookingId);
    final raw = response['data'];
    if (raw is! Map<String, dynamic>) {
      throw Exception('Unexpected location response format');
    }
    return CaregiverLocationModel.fromJson(raw);
  }
}
