import 'dart:io';
import 'package:ehtemam_final_project/core/widgets/full_screen_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_task_model.dart';
import '../../manager/mytask_cg_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class MytaskCgTaskItem extends StatelessWidget {
  final MytaskCgTaskModel task;
  final String bookingId;

  const MytaskCgTaskItem({
    super.key,
    required this.task,
    required this.bookingId,
  });

  // ── Extra-task state helpers ─────────────────────────────────────────────
  bool get _isPendingApproval =>
      task.isAddedByCaregiver && task.taskState == 'Pending Client Approval';
  bool get _isRejected =>
      task.isAddedByCaregiver && task.taskState == 'Rejected';
  bool get _isApproved =>
      task.isAddedByCaregiver && task.taskState == 'Approved';

  /// Extra tasks can only be interacted with (proof/done) once approved.
  bool get _canInteract => !task.isAddedByCaregiver || _isApproved;

  Color get _statusColor {
    if (_isPendingApproval) return const Color(0xFFF59E0B); // amber
    if (_isRejected)        return const Color(0xFFEF4444); // red
    if (_isApproved)        return const Color(0xFF22C55E); // green
    return task.isDone
        ? const Color(0xFF1976D2)  // blue
        : const Color(0xFFF59E0B); // amber
  }

  String get _statusLabel {
    if (_isPendingApproval) return 'Pending Approval';
    if (_isRejected)        return 'Rejected';
    if (_isApproved)        return 'Approved';
    return task.status; // "Pending" | "Completed"
  }

  @override
  Widget build(BuildContext context) {
    final cubit    = context.read<MytaskCgCubit>();
    final hasProof = task.mediaProof.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _isRejected
            ? const Color(0xFFFFF5F5)
            : _isPendingApproval
                ? const Color(0xFFFFFBEB)
                : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: _isPendingApproval || _isRejected
            ? Border.all(
                color: _statusColor.withValues(alpha: 0.4),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(64, 0, 0, 0),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ─────────────────────────────────────────────────────
          Row(
            children: [
              // Checkbox — locked when proof missing OR extra task not yet approved
              GestureDetector(
                onTap: () {
                  if (!_canInteract) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isPendingApproval
                            ? 'Waiting for client approval before completing this task.'
                            : _isRejected
                                ? 'This task was rejected by the client.'
                                : 'Upload photo/video proof before marking as done'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  if (!hasProof) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('upload_proof_before_done'.tr()),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  cubit.toggleTaskDone(bookingId, task.id);
                },
                child: Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isDone
                          ? const Color(0xFF1976D2)
                          : !_canInteract
                              ? Colors.grey.shade300
                              : hasProof
                                  ? Colors.grey
                                  : Colors.grey.shade300,
                      width: 2.w,
                    ),
                    color: task.isDone
                        ? const Color(0xFF1976D2)
                        : Colors.transparent,
                  ),
                  child: task.isDone
                      ? Icon(Icons.check, size: 14.r, color: Colors.white)
                      : Icon(Icons.lock_outline,
                          size: 12.r, color: Colors.grey.shade300),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              if (task.isAddedByCaregiver)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.r),
                  onPressed: () => cubit.deleteTask(bookingId, task.id),
                )
              else
                SizedBox(width: 40.w),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(left: 8.w, top: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Price (for extra tasks) ──────────────────────────────
                if (task.price > 0) ...[
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 14.r, color: const Color(0xFF1976D2)),
                      Text(
                        'EGP ${task.price.toStringAsFixed(task.price % 1 == 0 ? 0 : 2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],

                // ── Description ──────────────────────────────────────────
                if (task.description.isNotEmpty && task.description != task.title) ...[
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 6.h),
                ],

                // ── Pending-approval notice ──────────────────────────────
                if (_isPendingApproval) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.hourglass_empty, size: 14.r, color: const Color(0xFFD97706)),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text('waiting_client_approval'.tr(),
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD97706)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],

                // ── Rejected notice ──────────────────────────────────────
                if (_isRejected) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cancel_outlined, size: 14.r, color: const Color(0xFFDC2626)),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text('client_rejected_task'.tr(),
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFDC2626)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],

                // ── Meta row: client + category ──────────────────────────
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14.r, color: Colors.black87),
                    SizedBox(width: 4.w),
                    Text(
                      task.assignedTo.isNotEmpty ? task.assignedTo : '—',
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                    SizedBox(width: 12.w),
                    if (task.category.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(fontSize: 11.sp, color: Colors.blue.shade700),
                        ),
                      ),
                    if (task.taskType.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.taskType,
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),

                if (task.date.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 13.r, color: Colors.black87),
                      SizedBox(width: 4.w),
                      Text(task.date, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                    ],
                  ),

                if (task.checkInTime.isNotEmpty || task.checkOutTime.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (task.checkInTime.isNotEmpty) ...[
                        Icon(Icons.login, size: 13.r, color: Colors.green.shade600),
                        SizedBox(width: 3.w),
                        Text(
                          'In: ${task.checkInTime}',
                          style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      if (task.checkOutTime.isNotEmpty) ...[
                        Icon(Icons.logout, size: 13.r, color: Colors.orange.shade600),
                        SizedBox(width: 3.w),
                        Text(
                          'Out: ${task.checkOutTime}',
                          style: TextStyle(fontSize: 11.sp, color: Colors.orange.shade700),
                        ),
                      ],
                    ],
                  ),
                ],

                // ── Proof thumbnails ─────────────────────────────────────
                if (task.mediaProof.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.attach_file, size: 13.r, color: Colors.black),
                      Text(
                        ' Attached Media (${task.mediaProof.length})',
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: task.mediaProof.length,
                      separatorBuilder: (_, _) => SizedBox(width: 8.w),
                      itemBuilder: (_, i) {
                        final path = task.mediaProof[i];
                        final isVideo = path.endsWith('.mp4') ||
                            path.endsWith('.mov') ||
                            path.endsWith('.avi');
                        final isUrl = path.startsWith('http');
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: isVideo
                              ? Container(
                                  width: 70.w,
                                  height: 70.h,
                                  color: Colors.black87,
                                  child: Icon(Icons.play_circle_fill,
                                      color: Colors.white, size: 32.r),
                                )
                              : isUrl
                                  ? GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImagePage(imageUrl: path),
                                        ),
                                      ),
                                      child: Image.network(
                                        path,
                                        width: 70.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          width: 70.w,
                                          height: 70.h,
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.broken_image, color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(path),
                                      width: 70.w,
                                      height: 70.h,
                                      fit: BoxFit.cover,
                                    ),
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: 8.h),

                // ── Upload proof button — hidden for non-approved extra tasks ─
                if (_canInteract)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await cubit.addMediaToTask(bookingId, task.id);
                      if (!context.mounted) return;
                      if (result == null) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.isEmpty
                              ? 'Proof uploaded successfully'
                              : 'Upload failed: $result'),
                          backgroundColor: result.isEmpty ? Colors.green : Colors.red,
                        ),
                      );
                    },
                    icon: Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.blue, size: 16.r),
                    label: Text(
                      hasProof ? 'Add More Proof' : 'Add Photo / Video Proof',
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      side: const BorderSide(color: Colors.grey),
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
