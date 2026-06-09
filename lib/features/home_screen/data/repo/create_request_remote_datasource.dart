import '../../../../core/network/api_service.dart';

abstract class CreateRequestRemoteDatasource {
  Future<void> createRequest({
    required String serviceId,
    required String date,
    required String time,
    String? duration,
    String? notes,
    required String location,
    String? budget,

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
    required String location,
    required String date,
    required String time,
    String? duration,
    String? notes,
    String? budget,

  }) async {

    await apiService.createRequest(
      serviceId: serviceId,
      location: location,
      date: date,
      time: time,
      duration: duration,
      notes: notes,
      budget: budget,
    );
  }
}