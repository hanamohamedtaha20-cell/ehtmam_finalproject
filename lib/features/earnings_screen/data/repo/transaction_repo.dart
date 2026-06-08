import 'package:ehtemam_final_project/core/network/api_service.dart';

class CreateRequestRepository {
  final ApiService _apiService;

  CreateRequestRepository(this._apiService);

  Future<void> createRequest({
    required String serviceId,
    required String location,
    required String date,
    required String time,
    String? duration,
    String? notes,
  }) async {
    await _apiService.createRequest(
      serviceId: serviceId,
      location: location,
      date: date,
      time: time,
      duration: duration,
      notes: notes,
    );
  }
}