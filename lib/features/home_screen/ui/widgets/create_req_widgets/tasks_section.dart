import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final TextEditingController _taskController = TextEditingController();

  void addTask() {
    context.read<CreateRequestCubit>().addTask(_taskController.text);
    _taskController.clear();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRequestCubit, CreateRequestState>(
      builder: (context, state) {
        final tasks = context.read<CreateRequestCubit>().tasks;
        final cubit = context.read<CreateRequestCubit>();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 18,
                    color: const Color(0xFF4A90E2),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Tasks",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2D42),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Add specific tasks you'd like the caregiver to complete",
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          hintText: "Enter a task...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => addTask(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: addTask,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (tasks.isNotEmpty) ...[
                const SizedBox(height: 14),
                Column(
                  children: List.generate(
                    tasks.length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A90E2),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tasks[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2B2D42),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => cubit.removeTask(index),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
