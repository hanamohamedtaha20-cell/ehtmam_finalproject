import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onConfirm;

  const ActionButtons({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
                ],
              ),
              child: Center(
                child: Text("Cancel",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp)),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: onConfirm,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.purple, AppColors.purple2]),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
                ],
              ),
              child: Center(
                child: Text("Confirm",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}