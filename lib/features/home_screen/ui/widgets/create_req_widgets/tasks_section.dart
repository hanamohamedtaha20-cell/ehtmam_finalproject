import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final TextEditingController _taskController = TextEditingController();

  void addTask() {
    context.read<CreateRequestCubit>().addTask(_taskController.text);
    _taskController.clear();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRequestCubit, CreateRequestState>(
      builder: (context, state) {
        final tasks = context.read<CreateRequestCubit>().tasks;
        final cubit = context.read<CreateRequestCubit>();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 18.r,
                    color: const Color(0xFF4A90E2),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Tasks",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2D42),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                "Add specific tasks you'd like the caregiver to complete",
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: Colors.grey.shade500,
                  height: 1.4.h,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          hintText: "Enter a task...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                        ),
                        onSubmitted: (_) => addTask(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: addTask,
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (tasks.isNotEmpty) ...[
                SizedBox(height: 14.h),
                Column(
                  children: List.generate(
                    tasks.length,
                    (index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: Color(0xFF4A90E2),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                tasks[index],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF2B2D42),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => cubit.removeTask(index),
                              child: Icon(
                                Icons.close,
                                size: 18.r,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
