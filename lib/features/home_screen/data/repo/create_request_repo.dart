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
  }) async {
    await remoteDatasource.createRequest(
      serviceId: serviceId,
      governorate: governorate,
      date: date,
      time: time,
      duration: duration,
      notes: notes,
    );
  }
}