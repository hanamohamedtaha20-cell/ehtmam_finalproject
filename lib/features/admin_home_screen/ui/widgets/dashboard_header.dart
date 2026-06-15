import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 14, 16, 0),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 18, 16, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.r).copyWith(
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff4A90E2),
            Color(0xff76BDFB),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.language, size: 13.r, color: Color(0xff315A7C)),
                    SizedBox(width: 6.w),
                    Text(
                      'ع',
                      style: TextStyle(
                        color: Color(0xff315A7C),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Ehtemam',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Sunday, March 8, 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}