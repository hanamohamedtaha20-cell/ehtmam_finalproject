import 'package:ehtemam_final_project/core/network/api_services.dart';
import '../model/task_model.dart';

class TaskRepo {
  final ApiService _api = ApiService();

  Future<List<TaskModel>> getTasks() async {
    final result = await _api.getAllTasks();
    if (result['status'] == 'success') {
      final list = result['data'] as List? ?? [];
      return list.map((t) => TaskModel.fromJson(t)).toList();
    }
    return [];
  }

  Future<void> addTask(String description) async {
    await _api.createTask(description: description);
  }
}