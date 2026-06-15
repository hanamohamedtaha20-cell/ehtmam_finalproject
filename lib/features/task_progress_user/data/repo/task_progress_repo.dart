import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_progress_model.dart';

class TaskProgressRepo {
  final ApiService _api = ApiService();

  Future<List<TaskProgressModel>> getTasks(String bookingId) async {
    final response = await _api.getTaskProgress(bookingId);
    final data = response['data'];
    final list = data is List ? data : (data is Map ? data['tasks'] ?? [] : []);
    return (list as List)
        .whereType<Map<String, dynamic>>()
        .map(TaskProgressModel.fromJson)
        .toList();
  }
}