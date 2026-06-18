import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/repo/mytask_cg_repo.dart';
import '../../manager/mytask_cg_cubit.dart';
import '../../manager/mytask_cg_state.dart';
import '../widgets/mytask_cg_stats_header.dart';
import '../widgets/mytask_cg_filter_tabs.dart';
import '../widgets/mytask_cg_task_item.dart';
import '../widgets/mytask_cg_add_task_sheet.dart';
import '../widgets/mytask_cg_checkin_bar.dart';

class MytaskCgScreen extends StatelessWidget {
  final String? bookingId;
  const MytaskCgScreen({super.key, this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = MytaskCgCubit(MytaskCgRepo());
        // Fast path: bookingId known → GET /booking/{id}/tasks directly.
        // Slow path: no bookingId → load all active bookings.
        if (bookingId != null && bookingId!.isNotEmpty) {
          cubit.loadTasksForBooking(bookingId!);
        } else {
          cubit.loadBookings();
        }
        return cubit;
      },
      child: _MytaskCgView(bookingId: bookingId),
    );
  }
}

class _MytaskCgView extends StatelessWidget {
  final String? bookingId;
  const _MytaskCgView({this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Tasks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<MytaskCgCubit, MytaskCgState>(
        builder: (context, state) {
          if (state is MytaskCgLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MytaskCgError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      final cubit = context.read<MytaskCgCubit>();
                      if (bookingId != null && bookingId!.isNotEmpty) {
                        cubit.loadTasksForBooking(bookingId!);
                      } else {
                        cubit.loadBookings();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is! MytaskCgLoaded) return const SizedBox();

          final cubit = context.read<MytaskCgCubit>();

          final targetBooking = bookingId != null
              ? state.bookings
                  .where((b) => b.bookingId == bookingId)
                  .firstOrNull
              : state.bookings.firstOrNull;

          final sourceTasks = targetBooking != null
              ? targetBooking.tasks
              : state.allTasks;

          final pendingCount   = sourceTasks.where((t) => !t.isDone).length;
          final completedCount = sourceTasks.where((t) => t.isDone).length;

          final filteredTasks = state.filter == 'pending'
              ? sourceTasks.where((t) => !t.isDone).toList()
              : state.filter == 'done'
                  ? sourceTasks.where((t) => t.isDone).toList()
                  : sourceTasks;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    MytaskCgStatsHeader(
                      pendingCount: pendingCount,
                      completedCount: completedCount,
                    ),
                    SizedBox(height: 12.h),
                    MytaskCgFilterTabs(
                      selected: state.filter,
                      allCount: sourceTasks.length,
                      pendingCount: pendingCount,
                      doneCount: completedCount,
                      onFilter: cubit.filterBookings,
                    ),
                    SizedBox(height: 12.h),
                    if (targetBooking != null)
                      MytaskCgCheckinBar(booking: targetBooking),
                    if (targetBooking != null) SizedBox(height: 12.h),
                  ],
                ),
              ),
              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks found',
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks.elementAt(index);
                          final bid = targetBooking?.bookingId ??
                              state.getBookingForTask(task.id)?.bookingId ??
                              '';
                          return MytaskCgTaskItem(
                            task: task,
                            bookingId: bid,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<MytaskCgCubit, MytaskCgState>(
        builder: (context, state) {
          if (state is! MytaskCgLoaded) return const SizedBox();
          final bid = bookingId ?? state.bookings.firstOrNull?.bookingId;
          if (bid == null) return const SizedBox();
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => MytaskCgAddTaskSheet(
                  bookingId: bid,
                  onAdd: (taskName) =>
                      context.read<MytaskCgCubit>().addTask(bid, taskName),
                ),
              );
            },
            backgroundColor: const Color(0xFF1976D2),
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
