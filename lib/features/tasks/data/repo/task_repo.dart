import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';

class TaskRepo {
  List<TaskModel> getTasks() {
    return [
      const TaskModel(
        id: '1',
        description: 'Pick dog food and favorite toys',
        category: TaskCategory.petCare,
        status: TaskStatus.active,
      ),
      const TaskModel(
        id: '2',
        description: 'Write down feeding schedule and special instructions',
        category: TaskCategory.petCare,
        status: TaskStatus.active,
      ),
      const TaskModel(
        id: '3',
        description: 'Prepare medication and vet contact info',
        category: TaskCategory.petCare,
        status: TaskStatus.active,
      ),
      const TaskModel(
        id: '4',
        description: 'Confirm service provider availability',
        category: TaskCategory.elderCare,
        status: TaskStatus.active,
      ),
      const TaskModel(
        id: '5',
        description: 'Prepare list of daily medications',
        category: TaskCategory.childCare,
        status: TaskStatus.active,
      ),
    ];
  }
}