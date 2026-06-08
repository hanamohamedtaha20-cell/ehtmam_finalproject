import 'package:ehtemam_final_project/features/task_progress_user/data/model/task_progress_model.dart';


abstract class TaskProgressState {}

class TaskProgressInitial extends TaskProgressState {}

class TaskProgressLoading extends TaskProgressState {}

class TaskProgressLoaded extends TaskProgressState {
  final List<TaskProgressModel> tasks;

  TaskProgressLoaded({required this.tasks});

  int get completedCount  => tasks.where((t) => t.isCompleted).length;
  int get totalCount      => tasks.length;
  double get progressValue =>
      totalCount == 0 ? 0 : completedCount / totalCount;
  String get progressPercent =>
      '${(progressValue * 100).toInt()}%';
}

class TaskProgressError extends TaskProgressState {
  final String message;
  TaskProgressError(this.message);
}