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
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;

    if (tasks.isEmpty) {
      return  Center(
        child: Text("No tasks found", style: TextStyle(fontFamily: "Arimo", color: Colors.grey)),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (_, i) {
              final isLast = i == tasks.length - 1;
              return Column(
                children: [
                  TaskItem(task: tasks[i], onToggle: onToggle, onDelete: onDelete),
                  if (!isLast) const SizedBox(height: 10),
                ],
              );
            },
            childCount: tasks.length,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        
      ],
    );
  }
}