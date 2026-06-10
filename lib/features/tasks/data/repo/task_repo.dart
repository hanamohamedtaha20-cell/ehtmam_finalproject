import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_model.dart';

class TaskRepo {
  final ApiService _api = ApiService();

  Future<List<TaskModel>> getTasksByRequestId(String requestId) async {
    final list = await _api.getTasksByRequestId(requestId);
    return list.asMap().entries.map((entry) {
      return TaskModel.fromJson(
        entry.value as Map<String, dynamic>,
        index: entry.key,
      );
    }).toList();
  }

  Future<void> addTask(String description) async {
    await _api.createTask(description: description);
  }
}