import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Color iconBackgroundColor;
  final Color cardColor;
  final VoidCallback onTap;
  final String? imagePath;

  const SelectRoleCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    required this.iconBackgroundColor,
    required this.cardColor,
    required this.onTap,
    this.imagePath,

  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 14.r,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: iconBackgroundColor.withOpacity(0.28),
                      blurRadius: 12.r,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  width: 5.w,
                  height: 5.h,
                  //fit: BoxFit.contain,
                )
                    : Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bold.copyWith(
                        fontSize: 18.sp,
                        color: const Color(0xFF1D293D),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 16.sp,
                        height: 1.35.h,
                        color: const Color(0xFF506177),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.r,
                color: Color(0xFF8B98AA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}