import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterHeader extends StatelessWidget {
  final String role;

  const RegisterHeader({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62.w,
          height: 62.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7EC4F0),
                Color(0xFF4A8BC3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A8BC3).withOpacity(0.35),
                blurRadius: 14.r,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 28.r,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          '$role Register',
          textAlign: TextAlign.center,
          style: AppTextStyle.bold.copyWith(
            fontSize: 28.sp,
            color: const Color(0xFF22304A),
          ),
        ),
        SizedBox(height: 4.h),
        Text('documents_required'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 12.sp,
            color: const Color(0xFFFB2C36),
          ),
        ),
      ],
    );
  }
}