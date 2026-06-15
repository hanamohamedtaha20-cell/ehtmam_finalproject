import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdUserStatsCard extends StatelessWidget {
  final int total;

  const AdUserStatsCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            total.toString(),
            style: TextStyle(
              color: Color(0xff2F93E6),
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Total Users',
            style: TextStyle(
              color: Color(0xff111827),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}