import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final int selectedTab;
  final String searchQuery;

  TaskLoaded({
    required this.tasks,
    this.selectedTab = 0,
    this.searchQuery = '',
  });

  List<TaskModel> get filtered {
    List<TaskModel> result = tasks;
    if (selectedTab == 1) result = result.where((t) => t.status == TaskStatus.active).toList();
    if (selectedTab == 2) result = result.where((t) => t.status == TaskStatus.completed).toList();
    if (searchQuery.isNotEmpty) {
      result = result.where((t) =>
          t.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    return result;
  }

  int get activeCount    => tasks.where((t) => t.status == TaskStatus.active).length;
  int get completedCount => tasks.where((t) => t.status == TaskStatus.completed).length;
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}