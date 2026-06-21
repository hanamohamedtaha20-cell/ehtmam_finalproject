import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdProviderStatsCard extends StatelessWidget {
  final int total;

  const AdProviderStatsCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            total.toString(),
            style: TextStyle(
              color: const Color(0xff2F93E6),
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Total Providers',
            style: TextStyle(
              color: const Color(0xff64748B),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
