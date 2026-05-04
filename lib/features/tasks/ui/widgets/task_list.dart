import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/task_item.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TaskList({super.key, required this.tasks, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text("No tasks found", style: TextStyle(fontFamily: "Arimo", color: Colors.grey)),
      );
    }
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => TaskItem(task: tasks[i], onToggle: onToggle, onDelete: onDelete),
    );
  }
}