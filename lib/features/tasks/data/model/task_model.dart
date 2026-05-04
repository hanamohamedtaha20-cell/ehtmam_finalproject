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
      case TaskCategory.petCare: return "Pet Care";
      case TaskCategory.elderCare: return "Elder Care";
      case TaskCategory.childCare: return "Child Care";
    }
  }
}