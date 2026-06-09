import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_cubit.dart';
import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/search_field.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/stats_row.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/tab_bar.dart';
import 'package:ehtemam_final_project/features/tasks/ui/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../widgets/add_task_dialog.dart';

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
            padding:  EdgeInsets.all(16),
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestsScreen(),
                                ),
                              );
                            },
                            child: Icon(Icons.arrow_back)),
                         Text("My Tasks", style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                         Spacer(),
                     //localization
                      ],
                    ),
                     SizedBox(height: 16),

                    /// Stats
                    StatsRow(activeCount: state.activeCount, completedCount: state.completedCount),
                     SizedBox(height: 16),


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

                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff3A8BD7),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => showAddTaskDialog(context),
        ),
      ),
    );
  }
}