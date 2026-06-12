import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_progress_model.dart';

class TaskProgressRepo {
  final ApiService _api = ApiService();

  Future<List<TaskProgressModel>> getTasks() async {
    final list = await _api.fetchTasks();
    return list
        .whereType<Map<String, dynamic>>()
        .map(TaskProgressModel.fromJson)
        .toList();
  }
}