import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';

abstract class CreateRequestRemoteDatasource {
  Future<void> createRequest({
    required String serviceId,
    required String serviceType,
    required String governorate,
    required String date,
    required String time,
    String? description,
    String? duration,
    String? notes,
    String? budget,
    List<String> tasks = const [],
  });
}

class CreateRequestRemoteDatasourceImpl implements CreateRequestRemoteDatasource {
  final ApiService apiService;

  CreateRequestRemoteDatasourceImpl(this.apiService);

  @override
  Future<void> createRequest({
    required String serviceId,
    required String serviceType,
    required String governorate,
    required String date,
    required String time,
    String? description,
    String? duration,
    String? notes,
    String? budget,
    List<String> tasks = const [],
  }) async {
    debugPrint('SERVICE_TYPE_SENT: $serviceType');
    await apiService.createRequest(
      serviceId:   serviceId,
      serviceType: serviceType,
      governorate: governorate,
      date:        date,
      time:        time,
      description: description,
      budget:      num.tryParse(budget ?? '') ?? 0,
      tasks:       tasks,
      duration:    duration,
      notes:       notes,
    );
  }
}
