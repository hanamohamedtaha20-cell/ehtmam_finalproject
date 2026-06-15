import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const BookingInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.r, color: AppColors.blue), // 👈 blue icon
        SizedBox(width: 6.w),
        Text(text,
            style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 12.sp,
                color: AppColors.textDark)), // 👈 dark text
      ],
    );
  }
}