import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProviderNotes extends StatelessWidget {
  final String description;

  ProviderNotes({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 العنوان برّه البوكس
        Text('provider_proposal'.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        SizedBox(height: 10.h),

        /// 🔹 الكارد
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12.r,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 Title جوه الكارد
              Text('provider_notes'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 8.h),

              /// 🔹 Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF6B7280),
                  height: 1.5.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}