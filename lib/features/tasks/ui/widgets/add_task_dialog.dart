import 'package:ehtemam_final_project/features/tasks/manager/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

void showAddTaskDialog(BuildContext context) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text('add_new_task'.tr(),
        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('task_description'.tr(),
            style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 13.sp),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'enter_task_desc'.tr(),
              hintStyle: TextStyle(fontFamily: "Arimo", fontSize: 13.sp),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            side: BorderSide(color: Colors.grey, width: 1.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr(),
            style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff3A8BD7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
          icon: Icon(Icons.add, color: Colors.white, size: 16.r),
          label: Text('add_task'.tr(),
            style: TextStyle(fontFamily: "Arimo", color: Colors.white),
          ),
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              context.read<TaskCubit>().addTask(controller.text.trim());
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
  );
}