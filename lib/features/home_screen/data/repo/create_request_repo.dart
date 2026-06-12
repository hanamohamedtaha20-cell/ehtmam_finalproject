import 'create_request_remote_datasource.dart';

abstract class CreateRequestRepository {
  Future<void> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    String? duration,
    String? budget,
    String? notes,
    List<String> tasks = const [],
  });
}

class CreateRequestRepositoryImpl
    implements CreateRequestRepository {

  final CreateRequestRemoteDatasource remoteDatasource;

  CreateRequestRepositoryImpl(
      this.remoteDatasource,
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
    await remoteDatasource.createRequest(
      serviceId: serviceId,
      governorate: governorate,
      date: date,
      time: time,
      duration: duration,
      notes: notes,
      budget: budget,
      tasks: tasks,
    );
  }
}