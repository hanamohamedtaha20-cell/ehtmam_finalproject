import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TaskItem({super.key, required this.task, required this.onToggle, required this.onDelete});

  Color get _categoryColor {
    switch (task.category) {
      case TaskCategory.petCare: return AppColors.bg1;
      case TaskCategory.elderCare: return AppColors.bg1;
      case TaskCategory.childCare: return AppColors.bg1;
    }
  }

  Color get _categoryTextColor {
    switch (task.category) {
      case TaskCategory.petCare: return AppColors.purple2;
      case TaskCategory.elderCare: return AppColors.purple;
      case TaskCategory.childCare: return AppColors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onToggle(task.id),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? AppColors.blue : Colors.grey.shade300, width: 2),
                color: isCompleted ? AppColors.blue : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _categoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.categoryName,
                    style: TextStyle(fontFamily: "Arimo", fontSize: 10, color: _categoryTextColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onDelete(task.id),
            child: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}