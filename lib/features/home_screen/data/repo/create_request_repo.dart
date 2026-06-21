import 'create_request_remote_datasource.dart';

abstract class CreateRequestRepository {
  Future<void> createRequest({
    required String serviceId,
    required String serviceType,
    required String governorate,
    required String date,
    required String time,
    String? description,
    String? duration,
    String? budget,
    String? notes,
    String? serviceType,
    List<String> tasks = const [],
  });
}

class CreateRequestRepositoryImpl implements CreateRequestRepository {
  final CreateRequestRemoteDatasource remoteDatasource;

  CreateRequestRepositoryImpl(this.remoteDatasource);

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
    String? serviceType,
    List<String> tasks = const [],
  }) async {
    await remoteDatasource.createRequest(
      serviceId:   serviceId,
      serviceType: serviceType,
      governorate: governorate,
      date:        date,
      time:        time,
      description: description,
      duration: duration,
      notes: notes,
      budget: budget,
      serviceType: serviceType,
      tasks: tasks,
    );
  }
}
