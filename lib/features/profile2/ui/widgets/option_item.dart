import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  VoidCallback? onTap;

   OptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color, 
    this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 18.r, color: Colors.white),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 14.sp,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14.r, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}