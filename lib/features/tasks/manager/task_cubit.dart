import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  void loadTasks() {
    emit(TaskLoaded(tasks: [
      const TaskModel(id: '1', description: 'Pick dog food and favorite toys', category: TaskCategory.petCare, status: TaskStatus.active),
      const TaskModel(id: '2', description: 'Write down feeding schedule and special instructions', category: TaskCategory.petCare, status: TaskStatus.active),
      const TaskModel(id: '3', description: 'Prepare medication and vet contact info', category: TaskCategory.petCare, status: TaskStatus.active),
      const TaskModel(id: '4', description: 'Confirm service provider availability', category: TaskCategory.elderCare, status: TaskStatus.active),
      const TaskModel(id: '5', description: 'Prepare list of daily medications', category: TaskCategory.childCare, status: TaskStatus.active),
    ]));
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
            id: t.id,
            description: t.description,
            category: t.category,
            status: t.status == TaskStatus.active ? TaskStatus.completed : TaskStatus.active,
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
        tasks: s.tasks.where((t) => t.id != id).toList(),
        selectedTab: s.selectedTab,
        searchQuery: s.searchQuery,
      ));
    }
  }
}