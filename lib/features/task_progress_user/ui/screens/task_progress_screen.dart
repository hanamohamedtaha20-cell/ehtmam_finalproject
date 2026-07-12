import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen_user.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/screens/recharge_screen.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/model/task_progress_model.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_cubit.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/progress_card.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/widgets/task_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
          title: Text('task_progress'.tr(),
            style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          actions: [
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                tooltip: 'refresh'.tr(),
                onPressed: () =>
                    ctx.read<TaskProgressCubit>().loadTasks(bookingId),
              ),
            ),
          ],
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
                    Text('could_not_load_tasks'.tr(),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () =>
                          context.read<TaskProgressCubit>().loadTasks(bookingId),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }
            if (state is! TaskProgressLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TaskProgressCubit>().loadTasks(bookingId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: ProgressCard(
                        progressValue:   state.progressValue,
                        progressPercent: state.progressPercent,
                        completedCount:  state.completedCount,
                        totalCount:      state.totalCount,
                        workingStatus:   state.workingStatus,
                        checkInTime:     state.checkInTime,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Extra tasks ─────────────────────────────────────
                          if (state.allExtraTasks.isNotEmpty) ...[
                            _SectionHeader(
                              label: 'Extra Tasks',
                              count: state.allExtraTasks.length,
                              color: const Color(0xFFF59E0B),
                            ),
                            SizedBox(height: 8.h),
                            ...state.allExtraTasks.map((task) {
                              debugPrint('TASK_STATUS: ${task.taskState}');

                              // ── Rejected → completely hidden ────────────────
                              if (task.isRejected) {
                                return const SizedBox.shrink();
                              }

                              // ── Pending → special approval card with buttons ─
                              if (task.isPendingApproval) {
                                return _ExtraTaskCard(
                                  key: ValueKey(task.id),
                                  task: task,
                                  bookingId: bookingId,
                                );
                              }

                              // ── Approved / Completed → normal task card ──────
                              return Column(
                                key: ValueKey('extra_done_${task.id}'),
                                children: [
                                  TaskProgressItem(
                                    title: task.title,
                                    time: task.isCompleted ? 'Completed' : 'Approved',
                                    isDone: task.isCompleted,
                                    mediaCount: 0,
                                    mediaUrls: const [],
                                  ),
                                  SizedBox(height: 12.h),
                                ],
                              );
                            }),
                            SizedBox(height: 16.h),
                          ],

                          // ── Regular tasks ───────────────────────────────────
                          if (state.tasks.isNotEmpty) ...[
                            _SectionHeader(
                              label: 'Tasks',
                              count: state.tasks.length,
                              color: const Color(0xFF1976D2),
                            ),
                            SizedBox(height: 8.h),
                          ],
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
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0B2B5A),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Extra task approval card ───────────────────────────────────────────────────
// Only rendered for tasks in "Pending Client Approval" state.
// Approved / Completed tasks are rendered as TaskProgressItem by the parent.

class _ExtraTaskCard extends StatefulWidget {
  final ExtraTaskModel task;
  final String bookingId;

  const _ExtraTaskCard({
    super.key,
    required this.task,
    required this.bookingId,
  });

  @override
  State<_ExtraTaskCard> createState() => _ExtraTaskCardState();
}

class _ExtraTaskCardState extends State<_ExtraTaskCard> {
  bool _isActing = false;

  /// Optimistic: hides buttons immediately after approve API succeeds,
  /// before the BLoC refreshes after PaymentScreen is dismissed.
  bool _locallyApproved = false;

  /// Optimistic: hides the card immediately after reject API succeeds,
  /// before the BLoC refresh removes it from the list.
  bool _locallyRejected = false;

  Color get _cardColor =>
      _locallyApproved ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB);

  Color get _borderColor =>
      _locallyApproved ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

  // ── Action handler ──────────────────────────────────────────────────────────

  Future<void> _handle(bool approve) async {
    setState(() => _isActing = true);
    final cubit = context.read<TaskProgressCubit>();

    if (approve) {
      debugPrint('TASK_ID: ${widget.task.id}  price=${widget.task.price}');

      final result = await cubit.approveAndPayExtraTask(
        widget.task.id,
        bookingId: widget.bookingId,
        price: widget.task.price,
      );
      if (!mounted) return;
      setState(() => _isActing = false);

      if (result.isInsufficientFunds) {
        _showInsufficientFundsDialog(
          balance: result.walletBalance ?? 0,
          required: result.requiredAmount ?? widget.task.price,
        );
        return;
      }

      if (result.isError) {
        _showSnack(result.errorMessage ?? 'Payment failed', Colors.red);
        return;
      }

      // Success
      setState(() => _locallyApproved = true);
      _showSnack('extra_task_payment_success'.tr(), Colors.green);
      debugPrint('REFRESHING_TASKS');
      cubit.loadTasks(widget.bookingId);
    } else {
      // Reject
      debugPrint('TASK_STATUS: ${widget.task.taskState}');

      final error = await cubit.rejectExtraTask(widget.task.id);
      if (!mounted) return;
      setState(() => _isActing = false);

      if (error != null) {
        _showSnack(error, Colors.red);
        return;
      }

      // Immediately hide the card, show snack, then refresh.
      setState(() => _locallyRejected = true);
      _showSnack('Additional task rejected successfully.', Colors.orange);

      debugPrint('REFRESHING_TASKS');
      cubit.loadTasks(widget.bookingId);
    }
  }

  void _showSnack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  void _showInsufficientFundsDialog({required double balance, required double required}) {
    final shortfall = required - balance;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet_outlined, color: Colors.orange, size: 22.r),
            SizedBox(width: 8.w),
            Text('insufficient_balance'.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('insufficient_wallet_message'.tr(),
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
            ),
            SizedBox(height: 12.h),
            _BalanceRow(label: 'wallet_balance'.tr(),
                value: 'EGP ${balance.toStringAsFixed(2)}', color: Colors.red),
            SizedBox(height: 4.h),
            _BalanceRow(label: 'required_amount'.tr(),
                value: 'EGP ${required.toStringAsFixed(2)}', color: const Color(0xFF1976D2)),
            SizedBox(height: 4.h),
            _BalanceRow(label: 'shortfall'.tr(),
                value: 'EGP ${shortfall.toStringAsFixed(2)}', color: Colors.orange),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            icon: Icon(Icons.add, size: 16.r, color: Colors.white),
            label: Text('top_up_wallet'.tr(), style: const TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RechargeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Status badge ────────────────────────────────────────────────────────────

  Widget _statusBadge() {
    if (_locallyApproved) {
      return _badge(
        Icons.check_circle,
        'Approved',
        const Color(0xFF16A34A),
        const Color(0xFFDCFCE7),
      );
    }
    return _badge(
      Icons.hourglass_empty,
      'Pending Your Approval',
      const Color(0xFFD97706),
      const Color(0xFFFEF3C7),
    );
  }

  Widget _badge(IconData icon, String label, Color fg, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: fg),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Immediately hide while waiting for the BLoC refresh to drop it from the list.
    if (_locallyRejected) return const SizedBox.shrink();

    final task = widget.task;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _borderColor.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + price
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0B2B5A),
                  ),
                ),
              ),
              if (task.price > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'EGP ${task.price.toStringAsFixed(task.price % 1 == 0 ? 0 : 2)}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ),
            ],
          ),

          if (task.description.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              task.description,
              style: TextStyle(fontSize: 13.sp, color: Colors.black54),
            ),
          ],

          SizedBox(height: 10.h),
          _statusBadge(),

          // Accept / Reject buttons — hidden after local approve or while acting
          if (!_locallyApproved) ...[
            SizedBox(height: 12.h),
            _isActing
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handle(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFDC2626)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Text('reject'.tr()),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handle(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Text('accept'.tr()),
                        ),
                      ),
                    ],
                  ),
          ],
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BalanceRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
        Text(value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
