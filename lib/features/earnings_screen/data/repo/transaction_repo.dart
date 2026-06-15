import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter/material.dart';

class CreateRequestRepository {
  final ApiService _apiService;

  CreateRequestRepository(this._apiService);

  Future<void> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    required num budget,
    required List<String> tasks,
    String? duration,
    String? notes,
  }) async {
    await _apiService.createRequest(
      serviceId: serviceId,
      governorate: governorate,
      date: date,
      time: time,
      budget: budget,
      tasks: tasks,
      duration: duration,
      notes: notes,
    );
  }
}
