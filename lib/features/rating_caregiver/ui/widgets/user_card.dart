import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String role;

  const UserCard({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD3E1EF),
        borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
        //   BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        // ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF3A8BD7), Color(0xFF97CCFD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              
              child: Icon(
                Icons.person_outline,
                size: 28.r,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: AppColors.textDark)),
              Text('client'.tr(),
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }
}