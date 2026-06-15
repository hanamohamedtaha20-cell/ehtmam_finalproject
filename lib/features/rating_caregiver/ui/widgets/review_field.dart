import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewField extends StatelessWidget {
  final TextEditingController controller;

  const ReviewField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Write a Review (optional)",
            style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: AppColors.textDark)),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Share your thoughts about the service...",
            hintStyle: TextStyle(
                fontFamily: "Arimo",
                fontSize: 13.sp,
                color: AppColors.textLight),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(fontFamily: "Arimo", fontSize: 13.sp),
        ),
      ],
    );
  }
}