import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_cubit.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/progress_bar.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/search_field.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/stats_row.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/tab_bar.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit()..loadTasks(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is! TaskLoaded) return const Center(child: CircularProgressIndicator());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textDark),
                                  SizedBox(width: 4),
                                  Text("Back",
                                      style: TextStyle(
                                          fontFamily: "Arimo",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textDark)),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text("My Tasks", style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                        const Spacer(),
                     //localization
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Stats
                    StatsRow(activeCount: state.activeCount, completedCount: state.completedCount),
                    const SizedBox(height: 16),

                    /// Search
                    TaskSearchField(onChanged: (q) => context.read<TaskCubit>().search(q)),
                    const SizedBox(height: 16),

                    /// Tab Bar
                       TaskTabs(
                        selectedIndex: state.selectedTab,
                        allCount: state.tasks.length,
                        activeCount: state.activeCount,
                        completedCount: state.completedCount,
                        onTap: (i) => context.read<TaskCubit>().selectTab(i),
                      ),
                    const SizedBox(height: 12),

                    /// Task List
                    Expanded(
                      child: TaskList(
                        tasks: state.filtered,
                        onToggle: (id) => context.read<TaskCubit>().toggleTask(id),
                        onDelete: (id) => context.read<TaskCubit>().deleteTask(id),
                      ),
                    ),

                    /// Progress
                    TaskProgressBar(
                      completed: state.completedCount,
                      total: state.tasks.length,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        
      ),
    );
  }
}