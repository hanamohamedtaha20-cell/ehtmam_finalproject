import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialInstructionsCard extends StatelessWidget {
  final String instructions;

  const SpecialInstructionsCard({
    super.key,
    this.instructions = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: Color(0xff4B5A75),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "SPECIAL INSTRUCTIONS",
                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF4F0E2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              instructions.isNotEmpty
                  ? instructions
                  : 'No special instructions provided.',
              style: TextStyle(
                color: Color(0xff31456A),
                fontSize: 13.sp,
                height: 1.5.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
