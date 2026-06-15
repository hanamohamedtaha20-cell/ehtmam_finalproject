import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/tasks/data/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color get _categoryColor {
    switch (task.category) {
      case TaskCategory.petCare:
        return AppColors.bg1;

      case TaskCategory.elderCare:
        return AppColors.bg1;

      case TaskCategory.childCare:
        return AppColors.bg1;
    }
  }

  Color get _categoryTextColor {
    switch (task.category) {
      case TaskCategory.petCare:
        return AppColors.purple2;

      case TaskCategory.elderCare:
        return AppColors.purple;

      case TaskCategory.childCare:
        return AppColors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        task.status == TaskStatus.completed;

    return Dismissible(
      key: Key(task.id),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        onDelete(task.id);
      },

      background: Container(),

      secondaryBackground: Container(
        alignment: Alignment.centerRight,

        margin: EdgeInsets.all(2.r),

        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),

        decoration: BoxDecoration(
          color: const Color(0xFFFFEAEA),

          borderRadius: BorderRadius.circular(14.r),
        ),

        child: Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 28.r,
        ),
      ),

      child: Container(
        margin: EdgeInsets.all(2.r),

        padding: EdgeInsets.all(14.r),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(14.r),

          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 2),
              blurRadius: 4.r,
            ),

            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 6.r,
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// CHECKBOX
            GestureDetector(
              onTap: () => onToggle(task.id),

              child: Container(
                width: 22.w,
                height: 22.h,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: isCompleted
                        ? AppColors.blue
                        : Colors.grey.shade300,

                    width: 2.w,
                  ),

                  color: isCompleted
                      ? AppColors.blue
                      : Colors.transparent,
                ),

                child: isCompleted
                    ? Icon(
                  Icons.check,
                  size: 14.r,
                  color: Colors.white,
                )
                    : null,
              ),
            ),

            SizedBox(width: 12.w),

            /// TEXTS
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    task.description,

                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,

                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Container(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),

                    decoration: BoxDecoration(
                      color: _categoryColor,

                      borderRadius:
                      BorderRadius.circular(20.r),
                    ),

                    child: Text(
                      task.categoryName,

                      style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 10.sp,
                        color: _categoryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}