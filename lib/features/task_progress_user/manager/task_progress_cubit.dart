import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskProgressCubit extends Cubit<TaskProgressState> {
  final TaskProgressRepo _repo;

  TaskProgressCubit(this._repo) : super(TaskProgressInitial());

  Future<void> loadTasks(String bookingId) async {
    if (isClosed) return;
    emit(TaskProgressLoading());
    try {
      final tasks = await _repo.getTasks(bookingId);
      if (!isClosed) {
        emit(TaskProgressLoaded(tasks: tasks));
      }
    } catch (e) {
      if (!isClosed) {
        emit(TaskProgressError(e.toString()));
      }
    }
  }
}
