import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:ehtemam_final_project/features/tasks/data/repo/task_repo.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _repo = TaskRepo();
  final String requestId;

  TaskCubit({required this.requestId}) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await _repo.getTasksByRequestId(requestId);
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(String description) async {
    try {
      await _repo.addTask(description);
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> toggleTask(String id) async {
    if (state is! TaskLoaded) return;
    final s = state as TaskLoaded;

    // optimistic update أولاً عشان الـ UI يتحرك فوراً
    final updated = s.tasks.map((t) {
      if (t.id == id) {
        return TaskModel(
          id: t.id,
          description: t.description,
          category: t.category,
          status: t.status == TaskStatus.active
              ? TaskStatus.completed
              : TaskStatus.active,
        );
      }
      return t;
    }).toList();
    emit(TaskLoaded(tasks: updated, selectedTab: s.selectedTab, searchQuery: s.searchQuery));

    // بعدين ابعت للـ backend
    try {
      final task = s.tasks.firstWhere((t) => t.id == id);
      final newState = task.status == TaskStatus.active ? 'completed' : 'pending';
      await _repo.updateTaskState(id, newState);
    } catch (e) {
      // لو فشل ارجع للـ state القديم
      emit(TaskLoaded(tasks: s.tasks, selectedTab: s.selectedTab, searchQuery: s.searchQuery));
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> deleteTask(String id) async {
    if (state is! TaskLoaded) return;
    final s = state as TaskLoaded;

    // optimistic update
    emit(TaskLoaded(
      tasks: s.tasks.where((t) => t.id != id).toList(),
      selectedTab: s.selectedTab,
      searchQuery: s.searchQuery,
    ));

    try {
      await _repo.deleteTask(id);
    } catch (e) {
      // لو فشل ارجع للـ state القديم
      emit(TaskLoaded(tasks: s.tasks, selectedTab: s.selectedTab, searchQuery: s.searchQuery));
      emit(TaskError('Failed to delete task'));
    }
  }

  void selectTab(int index) {
    if (state is TaskLoaded) {
      final s = state as TaskLoaded;
      emit(TaskLoaded(tasks: s.tasks, selectedTab: index, searchQuery: s.searchQuery));
    }
  }

  void search(String query) {
    if (state is TaskLoaded) {
      final s = state as TaskLoaded;
      emit(TaskLoaded(tasks: s.tasks, selectedTab: s.selectedTab, searchQuery: query));
    }
  }
}