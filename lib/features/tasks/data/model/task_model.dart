enum TaskCategory { petCare, elderCare, childCare }
enum TaskStatus { active, completed }

class TaskModel {
  final String id;
  final String description;
  final TaskCategory category;
  final TaskStatus status;

  const TaskModel({
    required this.id,
    required this.description,
    required this.category,
    required this.status,
  });

  String get categoryName {
    switch (category) {
      case TaskCategory.petCare:   return "Pet Care";
      case TaskCategory.elderCare: return "Elder Care";
      case TaskCategory.childCare: return "Child Care";
    }
  }

  factory TaskModel.fromJson(Map<String, dynamic> json, {int index = 0}) {
    TaskCategory category;
    final type = (json['taskType'] ?? '').toString().toLowerCase();
    if (type.contains('pet'))   category = TaskCategory.petCare;
    else if (type.contains('elder')) category = TaskCategory.elderCare;
    else category = TaskCategory.childCare;

    final statusStr = (json['taskState'] ?? 'pending').toString().toLowerCase();
    final status = statusStr == 'completed'
        ? TaskStatus.completed
        : TaskStatus.active;

    return TaskModel(
      id:          json['_id']?.toString() ?? 'task_$index',
      description: json['taskDescription']?.toString() ?? '',
      category:    category,
      status:      status,
    );
  }
}