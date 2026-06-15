import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;
  const SubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSubmit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.lightBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: AppColors.purple.withOpacity(0.4),
                offset: Offset(0, 4),
                blurRadius: 12.r),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              "Submit Review",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}