import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HcStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const HcStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: Colors.white, size: 18.r),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B2B5A),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}
