import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_progress_model.dart';

class TaskProgressRepo {
  final ApiService _api = ApiService();

  Future<List<TaskProgressModel>> getTasks() async {
    final result = await _api.getAllTasks();
    final list = result['data'] as List? ?? [];
    return list.map((t) => TaskProgressModel.fromJson(t)).toList();
  }
}