import 'package:ehtemam_final_project/features/task_progress_user/data/model/task_progress_model.dart';

abstract class TaskProgressState {}

class TaskProgressInitial extends TaskProgressState {}

class TaskProgressLoading extends TaskProgressState {}

class TaskProgressLoaded extends TaskProgressState {
  final TaskProgressData data;

  TaskProgressLoaded(this.data);

  List<TaskProgressModel> get tasks        => data.tasks;
  int    get completedCount                => data.completedCount;
  int    get totalCount                    => data.totalCount;
  double get progressValue                 => totalCount == 0 ? 0 : data.progressPercent / 100;
  String get progressPercent               => '${data.progressPercent}%';
  String get workingStatus                 => data.workingStatus;
  String get checkInTime                   => data.checkInTime;
  String get caregiverName                 => data.caregiverName;
  String get serviceName                   => data.serviceName;
}

class TaskProgressError extends TaskProgressState {
  final String message;
  TaskProgressError(this.message);
}
