import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerformanceCard extends StatelessWidget {
  final CaregiverModel profile;

  const PerformanceCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 245, 249),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PERFORMANCE",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                  letterSpacing: 2)),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _StatBox(value: profile.totalRequests.toString(), label: "Total Requests", bgColor: Color(0xFF00A6F4), textColor: Colors.white)),
              SizedBox(width: 12.w),
              Expanded(child: _StatBox(value: "${profile.totalEarnings}K", label: "Total Earnings", bgColor: Color(0xFF1F9E0E), textColor:Colors.white )),
            ],
          ),
          
          
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color bgColor;
  final Color textColor;

  const _StatBox({
    required this.value,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60.w,  // 👈 small fixed width
          height: 60.h, // 👈 small fixed height
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    color: textColor)),
          ),
        ),
        SizedBox(height: 6.h),
        Text(label, // 👈 label outside the box
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 11.sp,
                color: AppColors.textLight)),
      ],
    );
  }
}