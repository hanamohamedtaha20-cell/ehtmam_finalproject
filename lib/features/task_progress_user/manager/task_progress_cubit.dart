import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskProgressCubit extends Cubit<TaskProgressState> {
  final TaskProgressRepo _repo;

  TaskProgressCubit(this._repo) : super(TaskProgressInitial());

  Future<void> loadTasks() async {
    emit(TaskProgressLoading());
    try {
      final tasks = await _repo.getTasks();
      emit(TaskProgressLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskProgressError(e.toString()));
    }
  }
}