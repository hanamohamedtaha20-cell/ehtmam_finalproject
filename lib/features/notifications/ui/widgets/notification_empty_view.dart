import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/core/resources/app_colors.dart';

class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 72.r,
            color: const Color(0xFFBFDAFF),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "You're all caught up!\nWe'll notify you when something new arrives.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 13.sp,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
