import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsCard extends StatelessWidget {
  final String value;
  final String title;
  final Color color;

  const StatsCard({
    super.key,
    required this.value,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 18.h,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.r,
            offset:  Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),

            decoration: BoxDecoration(
              color: color.withOpacity(0.18),

              borderRadius:
              BorderRadius.circular(18.r),

              boxShadow: [
                BoxShadow(
                  color:
                  color.withOpacity(0.2),
                  blurRadius: 8.r,
                  offset:  Offset(0, 6),
                ),
              ],
            ),

      child: Text(
        value,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
        ),
       ),
          ),

          SizedBox(height: 14.h),

          Text(
            title,

            style: TextStyle(
              color: const Color(0xFF475467),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}