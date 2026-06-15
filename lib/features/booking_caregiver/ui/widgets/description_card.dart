import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionCard extends StatelessWidget {
  final String description;

  const DescriptionCard({
    super.key,
    this.description = '',
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
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 6,
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
                color: const Color(0xff4B5A75),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "DESCRIPTION",
                style: TextStyle(
                  color: const Color(0xff4B5A75),
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
              color: const Color(0xffEAF1FB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              description.isNotEmpty
                  ? description
                  : 'No description provided.',
              style: TextStyle(
                color: const Color(0xff31456A),
                fontSize: 13.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
