import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectRoleLogoSection extends StatelessWidget {
  const SelectRoleLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 120.w,
          height: 120.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 18.h),
        Text('select_your_role'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'InriaSerif',
            fontWeight: FontWeight.w700,
            fontSize: 40.sp,
            color: Color(0xff45556C),

            shadows: [
              Shadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4.r,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text('trusted_care_platform'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 14.sp,
            color:  Color(0xFF3A8BD7),
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4.r,
              ),
            ],
          ),

        ),
      ],
    );
  }
}