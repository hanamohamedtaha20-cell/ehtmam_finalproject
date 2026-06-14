import '../../../../core/network/api_service.dart';

abstract class CreateRequestRemoteDatasource {
  Future<void> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    String? duration,
    String? notes,
    String? budget,
    List<String> tasks = const [],
  });
}

class CreateRequestRemoteDatasourceImpl
    implements CreateRequestRemoteDatasource {

  final ApiService apiService;

  CreateRequestRemoteDatasourceImpl(
      this.apiService,
      );

  @override
  Future<void> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    String? duration,
    String? notes,
    String? budget,
    List<String> tasks = const [],
  }) async {
    await apiService.createRequest(
      serviceId:   serviceId,
      governorate: governorate,
      date:        date,
      time:        time,
      budget:      num.tryParse(budget ?? '') ?? 0,
      tasks:       tasks,
      duration:    duration,
      notes:       notes,
    );
  }
}