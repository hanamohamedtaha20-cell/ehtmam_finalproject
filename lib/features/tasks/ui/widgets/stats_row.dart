import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsRow extends StatelessWidget {
  final int activeCount;
  final int completedCount;

  const StatsRow({super.key, required this.activeCount, required this.completedCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(label: "Active", count: activeCount, color: AppColors.blue)),
        SizedBox(width: 12.w),
        Expanded(child: _StatCard(label: "Completed", count: completedCount, color: Color(0xFF97CCFD), textColor: Colors.white)),      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color textColor;

  const _StatCard({required this.label, required this.count, required this.color, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count.toString(), style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 28.sp, color: textColor)),
          Text(label, style: TextStyle(fontFamily: "Arimo", fontSize: 13.sp, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}