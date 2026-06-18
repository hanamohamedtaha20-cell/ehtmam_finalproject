import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_task_model.dart';
import '../../manager/mytask_cg_cubit.dart';

class MytaskCgTaskItem extends StatelessWidget {
  final MytaskCgTaskModel task;
  final String bookingId;

  const MytaskCgTaskItem({
    super.key,
    required this.task,
    required this.bookingId,
  });

  Color get _statusColor =>
      task.isDone ? const Color(0xFF1976D2) : const Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MytaskCgCubit>();
    final hasProof = task.mediaProof.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          // ── Title row ───────────────────────────────────────────────────
          Row(
            children: [
              // Checkbox — disabled (grey) until proof uploaded
              GestureDetector(
                onTap: () {
                  if (!hasProof) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upload photo/video proof before marking as done'),
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
                      : !hasProof
                          ? Icon(Icons.lock_outline,
                              size: 12.r, color: Colors.grey.shade300)
                          : null,
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
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  task.status,
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
                  icon:
                      Icon(Icons.delete_outline, color: Colors.red, size: 20.r),
                  onPressed: () =>
                      cubit.deleteTask(bookingId, task.id),
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
                // ── Description (only if different from title) ───────────
                if (task.description.isNotEmpty &&
                    task.description != task.title) ...[
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 6.h),
                ],

                // ── Meta row: client + category ──────────────────────────
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 14.r, color: Colors.black87),
                    SizedBox(width: 4.w),
                    Text(
                      task.assignedTo.isNotEmpty ? task.assignedTo : '—',
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.black87),
                    ),
                    SizedBox(width: 12.w),
                    if (task.category.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.blue.shade700),
                        ),
                      ),
                    if (task.taskType.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.taskType,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),

                // ── Date row ─────────────────────────────────────────────
                if (task.date.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13.r, color: Colors.black87),
                      SizedBox(width: 4.w),
                      Text(
                        task.date,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.black87),
                      ),
                    ],
                  ),

                // ── Check-in / Check-out times ────────────────────────────
                if (task.checkInTime.isNotEmpty ||
                    task.checkOutTime.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (task.checkInTime.isNotEmpty) ...[
                        Icon(Icons.login,
                            size: 13.r, color: Colors.green.shade600),
                        SizedBox(width: 3.w),
                        Text(
                          'In: ${task.checkInTime}',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.green.shade700),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      if (task.checkOutTime.isNotEmpty) ...[
                        Icon(Icons.logout,
                            size: 13.r, color: Colors.orange.shade600),
                        SizedBox(width: 3.w),
                        Text(
                          'Out: ${task.checkOutTime}',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.orange.shade700),
                        ),
                      ],
                    ],
                  ),
                ],

                // ── Proof thumbnails ──────────────────────────────────────
                if (task.mediaProof.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.attach_file,
                          size: 13.r, color: Colors.black),
                      Text(
                        ' Attached Media (${task.mediaProof.length})',
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: task.mediaProof.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(width: 8.w),
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
                                  child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 32.r),
                                )
                              : isUrl
                                  ? Image.network(
                                      path,
                                      width: 70.w,
                                      height: 70.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          Container(
                                        width: 70.w,
                                        height: 70.h,
                                        color: Colors.grey.shade200,
                                        child: Icon(Icons.broken_image,
                                            color: Colors.grey),
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

                // ── Upload proof button ───────────────────────────────────
                OutlinedButton.icon(
                  onPressed: () async {
                    final result =
                        await cubit.addMediaToTask(bookingId, task.id);
                    if (!context.mounted) return;
                    if (result == null) return; // picker cancelled
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.isEmpty
                            ? 'Proof uploaded successfully'
                            : 'Upload failed: $result'),
                        backgroundColor:
                            result.isEmpty ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  icon: Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.blue, size: 16.r),
                  label: Text(
                    hasProof
                        ? 'Add More Proof'
                        : 'Add Photo / Video Proof',
                    style:
                        TextStyle(fontSize: 12.sp, color: Colors.blue),
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
