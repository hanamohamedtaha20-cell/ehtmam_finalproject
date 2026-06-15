import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsRow extends StatelessWidget {
  final int totalRequests;
  final int completed;
  final double rating;

  const StatsRow({
    super.key,
    required this.totalRequests,
    required this.completed,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(label: "totalRequests", value: totalRequests.toString(), color: Color(0xff9DCAF5), textColor: Color(0xff3A8BD7))),
        SizedBox(width: 10.w),
        Expanded(child: _StatCard(label: "completed", value: completed.toString(), color: AppColors.lightGreen, textColor: AppColors.green)),
        SizedBox(width: 10.w),
        Expanded(child: _StatCard(label: "Rating", value: rating.toString(), color: AppColors.lightOrange, textColor: AppColors.orange)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _StatCard({required this.label, required this.value, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 20.sp, color: textColor)),
          Text(label,
              style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}