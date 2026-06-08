import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:ehtemam_final_project/features/tasks/data/repo/task_repo.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _repo = TaskRepo();

  TaskCubit() : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await _repo.getTasks();
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

  void toggleTask(String id) {
    if (state is TaskLoaded) {
      final s = state as TaskLoaded;
      final updated = s.tasks.map((t) {
        if (t.id == id) {
          return TaskModel(
            id:          t.id,
            description: t.description,
            category:    t.category,
            status: t.status == TaskStatus.active
                ? TaskStatus.completed
                : TaskStatus.active,
          );
        }
        return t;
      }).toList();
      emit(TaskLoaded(tasks: updated, selectedTab: s.selectedTab, searchQuery: s.searchQuery));
    }
  }

  void deleteTask(String id) {
    if (state is TaskLoaded) {
      final s = state as TaskLoaded;
      emit(TaskLoaded(
        tasks:        s.tasks.where((t) => t.id != id).toList(),
        selectedTab:  s.selectedTab,
        searchQuery:  s.searchQuery,
      ));
    }
  }
}