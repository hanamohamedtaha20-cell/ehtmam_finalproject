import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskItemCard extends StatelessWidget {
  final String title;

  const TaskItemCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),

      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10.r,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: const Color(0xff1F2C44),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}