import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MytaskCgStatsHeader extends StatelessWidget {
  final int pendingCount;
  final int completedCount;

  const MytaskCgStatsHeader({
    super.key,
    required this.pendingCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'Pending', count: pendingCount, isDone: false),
        SizedBox(width: 12.w),
        _StatCard(label: 'Completed', count: completedCount, isDone: true),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final bool isDone;

  const _StatCard({required this.label, required this.count, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
        color: isDone ? const Color(0xFF97CCFD) : const Color(0xFF1976D2),          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: Colors.white,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                Text('$count', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}