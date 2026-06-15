import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/mytask_cg_repo.dart';
import '../../manager/mytask_cg_cubit.dart';
import '../../manager/mytask_cg_state.dart';
import '../widgets/mytask_cg_stats_header.dart';
import '../widgets/mytask_cg_filter_tabs.dart';
import '../widgets/mytask_cg_task_item.dart';
import '../widgets/mytask_cg_add_task_sheet.dart';
import '../widgets/mytask_cg_checkin_bar.dart';

class MytaskCgScreen extends StatelessWidget {
  const MytaskCgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MytaskCgCubit(MytaskCgRepo())..loadBookings(),      child: const _MytaskCgView(),
    );
  }
}

class _MytaskCgView extends StatelessWidget {
  const _MytaskCgView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text('My Tasks', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<MytaskCgCubit, MytaskCgState>(
        builder: (context, state) {
          if (state is MytaskCgLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is MytaskCgError) {
            return Center(child: Text(state.message));
          }
          if (state is MytaskCgLoaded) {
            final cubit = context.read<MytaskCgCubit>();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      MytaskCgStatsHeader(
                        pendingCount: state.pendingCount,
                        completedCount: state.completedCount,
                      ),
                      SizedBox(height: 12.h),
                      ...state.bookings.where((b) => b.isCheckedIn).map((booking) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: MytaskCgCheckinBar(booking: booking),
                      )),
                      SizedBox(height: 12.h),
                      MytaskCgFilterTabs(
                        selected: state.filter,
                        allCount: state.allTasks.length,
                        pendingCount: state.pendingCount,
                        doneCount: state.completedCount,
                        onFilter: cubit.filterBookings,
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      ...state.filteredTasks.map((task) {
                        final booking = state.getBookingForTask(task.id);
                        if (booking == null) return SizedBox();
                        return MytaskCgTaskItem(
                          task: task,
                          bookingId: booking.bookingId,
                          onAddProof: () => cubit.addMediaToTask(booking.bookingId, task.id),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<MytaskCgCubit, MytaskCgState>(
        builder: (context, state) {
          if (state is! MytaskCgLoaded) return SizedBox();
          return FloatingActionButton(
            onPressed: () {
              final bookings = state.bookings;
              if (bookings.isEmpty) return;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => MytaskCgAddTaskSheet(
                  bookingId: bookings.first.bookingId,
                  onAdd: (task) => context.read<MytaskCgCubit>().addTask(bookings.first.bookingId, task),
                ),
              );
            },
            backgroundColor: const Color(0xFF1976D2),
            child: Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}