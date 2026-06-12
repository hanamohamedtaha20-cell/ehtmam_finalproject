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
    final response = await apiService.createRequest(
      serviceId: serviceId,
      governorate: governorate,
      date: date,
      time: time,
      duration: duration,
      notes: notes,
      budget: budget,
    );

    if (tasks.isEmpty) return;

    final requestId = _extractRequestId(response);
    if (requestId == null || requestId.isEmpty) {
      throw Exception('Request created but no request ID returned for tasks');
    }

    await apiService.createRequestTasks(
      requestId: requestId,
      taskDescriptions: tasks,
    );
  }

  String? _extractRequestId(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data['_id']?.toString();
    }
    return response['_id']?.toString();
  }
}