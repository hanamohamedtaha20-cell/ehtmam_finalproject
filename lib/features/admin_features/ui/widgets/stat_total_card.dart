import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatTotalCard extends StatelessWidget {
  final String number;
  final String title;

  const StatTotalCard({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: Color(0xff2F93E6),
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Color(0xff6B7280),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}