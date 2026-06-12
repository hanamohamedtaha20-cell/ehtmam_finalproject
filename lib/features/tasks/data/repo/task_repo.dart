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

  Future<void> addTask(String requestId, String description) async {
    await _api.createRequestTasks(
      requestId: requestId,
      taskDescriptions: [description],
    );
  }
  Future<void> updateTaskState(String id, String taskState) async {
    await _api.updateTask(id: id, taskState: taskState);
  }

  Future<void> deleteTask(String id) async {
    await _api.deleteTask(id);
  }
}