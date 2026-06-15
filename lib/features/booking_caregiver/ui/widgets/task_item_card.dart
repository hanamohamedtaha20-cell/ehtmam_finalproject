import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskItemCard extends StatelessWidget {

  final String title;

  final bool isDone;

  final VoidCallback onTap;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 18.h,
        ),

        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),

          borderRadius:
          BorderRadius.circular(18.r),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10.r,
            ),
          ],
        ),

        child: Row(
          children: [

            /// CHECKBOX
            GestureDetector(
              onTap: onTap,

              child: Container(
                height: 22.h,
                width: 22.w,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: const Color(0xffD3D7DF),
                    width: 1.5.w,
                  ),

                  color: isDone
                      ? const Color(0xff2DBE1E)
                      : Colors.white,
                ),

                child: isDone
                    ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14.r,
                )
                    : null,
              ),
            ),

            SizedBox(width: 12.w),

            /// TITLE
            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  color: const Color(0xff1F2C44),

                  fontSize: 14.sp,

                  fontWeight: FontWeight.w500,

                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}