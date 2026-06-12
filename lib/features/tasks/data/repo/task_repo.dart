import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_model.dart';

class TaskRepo {
  final ApiService _api = ApiService();

  Future<List<TaskModel>> getTasks() async {
    final result = await _api.getAllTasks();
    final list = result['data'] as List? ?? [];
    return list.map((t) => TaskModel.fromJson(t)).toList();
  }

  Future<void> addTask(String description) async {
    await _api.createTask(description: description);
  }
  Future<void> updateTaskState(String id, String taskState) async {
    await _api.updateTask(id: id, taskState: taskState);
  }

  Future<void> deleteTask(String id) async {
    await _api.deleteTask(id);
  }
}