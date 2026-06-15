import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsHeaderCard extends StatelessWidget {
  final double totalEarnings;
  final String? trendText;

  const EarningsHeaderCard({
    super.key,
    this.totalEarnings = 0,
    this.trendText,
  });

  String get _formattedTotal {
    if (totalEarnings >= 1000) {
      return totalEarnings.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return totalEarnings.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 25.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF3D7FD1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Earnings",
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            _formattedTotal,
            style: TextStyle(
              fontSize: 40.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.h,
            ),
          ),
          if (trendText != null) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 12.r,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    trendText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
