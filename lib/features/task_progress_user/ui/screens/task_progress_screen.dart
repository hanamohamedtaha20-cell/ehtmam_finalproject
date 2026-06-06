import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen_user.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_cubit.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/progress_card.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/task_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskProgressScreen extends StatelessWidget {
  const TaskProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskProgressCubit(TaskProgressRepo())..loadTasks(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingScreenUser(),
              ),
            ),
          ),
          title: const Text(
            "Task Progress",
            style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<TaskProgressCubit, TaskProgressState>(
          builder: (context, state) {
            if (state is TaskProgressLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskProgressError) {
              return Center(child: Text(state.message));
            }
            if (state is! TaskProgressLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProgressCard( progressValue:   state.progressValue,
    progressPercent: state.progressPercent,
    completedCount:  state.completedCount,
    totalCount:      state.totalCount,),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...state.tasks.map((task) => Column(
                          children: [
                            TaskProgressItem(
                              title:     task.title,
                              time:      task.isCompleted ? 'Completed' : '',
                              isDone:    task.isCompleted,
                              mediaCount: task.proofUrl.isNotEmpty ? 1 : 0,
                              mediaUrls: task.proofUrl.isNotEmpty
                                  ? [task.proofUrl]
                                  : [],
                            ),
                            const SizedBox(height: 12),
                          ],
                        )),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}