import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen_user.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_cubit.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/progress_card.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/task_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskProgressScreen extends StatelessWidget {
  final String bookingId;

  const TaskProgressScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskProgressCubit(TaskProgressRepo())..loadTasks(bookingId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BookingScreenUser()),
            ),
          ),
          title: Text(
            "Task Progress",
            style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<TaskProgressCubit, TaskProgressState>(
          builder: (context, state) {
            if (state is TaskProgressLoading || state is TaskProgressInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskProgressError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 12.h),
                    Text(
                      "Could not load task progress",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () => context
                          .read<TaskProgressCubit>()
                          .loadTasks(bookingId),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            if (state is! TaskProgressLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: ProgressCard(
                    progressValue:  state.progressValue,
                    progressPercent: state.progressPercent,
                    completedCount:  state.completedCount,
                    totalCount:      state.totalCount,
                    workingStatus:   state.workingStatus,
                    checkInTime:     state.checkInTime,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        ...state.tasks.map((task) => Column(
                          children: [
                            TaskProgressItem(
                              title:      task.title,
                              time:       task.isCompleted
                                  ? (task.completionTime.isNotEmpty
                                      ? task.completionTime
                                      : 'Completed')
                                  : '',
                              isDone:     task.isCompleted,
                              mediaCount: task.mediaUrls.length,
                              mediaUrls:  task.mediaUrls,
                            ),
                            SizedBox(height: 12.h),
                          ],
                        )),
                        SizedBox(height: 16.h),
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
