import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_task_model.dart';
import '../../manager/mytask_cg_cubit.dart';

class MytaskCgTaskItem extends StatelessWidget {
  final MytaskCgTaskModel task;
  final String bookingId;
  final VoidCallback onAddProof;

  const MytaskCgTaskItem({
    super.key,
    required this.task,
    required this.bookingId,
    required this.onAddProof,
  });

  @override
  Widget build(BuildContext context) {
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
            offset: Offset(0, 2),
          ),
        ],
      ),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (task.mediaProof.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please add a photo/video proof first'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.read<MytaskCgCubit>().toggleTaskDone(bookingId, task.id);
              },
              child: Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isDone ? const Color(0xFF1976D2) : Colors.grey,
                    width: 2.w,
                  ),
                  color: task.isDone ? const Color(0xFF1976D2) : Colors.transparent,
                ),
                child: task.isDone
                    ? Icon(Icons.check, size: 14.r, color: Colors.white)
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
           if (task.isAddedByCaregiver)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.r),
              onPressed: () => context.read<MytaskCgCubit>().deleteTask(bookingId, task.id),
            )
          else
            SizedBox(width: 48.w),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14.r, color: Colors.black87),
                  SizedBox(width: 4.w),
                  Text(task.assignedTo, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                  SizedBox(width: 30.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(task.category, style: TextStyle(fontSize: 11.sp, color: Colors.blue.shade700)),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 13.r, color: Colors.black87),
                  SizedBox(width: 4.w),
                  Text(task.date, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                ],
              ),
              if (task.mediaProof.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.attach_file, size: 13.r, color: Colors.black),
                    Text(
                      ' Attached Media (${task.mediaProof.length})',
                      style: TextStyle(fontSize: 12.sp, color: Colors.black, ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  height: 70.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.mediaProof.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (_, i) {
                      final path = task.mediaProof[i];
                      final isVideo = path.endsWith('.mp4') ||
                          path.endsWith('.mov') ||
                          path.endsWith('.avi');
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: isVideo
                            ? Container(
                                width: 70.w,
                                height: 70.h,
                                color: Colors.black87,
                                child: Icon(Icons.play_circle_fill, color: Colors.white, size: 32.r),
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
              OutlinedButton.icon(
                onPressed: onAddProof,
                icon: Icon(Icons.add_photo_alternate_outlined, color: Colors.blue,size: 16.r),
                label: Text('Add Photo/Video Proof', style: TextStyle(fontSize: 12.sp , color: Colors.blue),),
                style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(color: Colors.grey),
                foregroundColor: Colors.grey.shade700,
              ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View Booking Details →',
                    style: TextStyle(fontSize: 12.sp, color: Color(0xFF1976D2))),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    ));
  }
}