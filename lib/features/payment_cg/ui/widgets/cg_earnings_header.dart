import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CgEarningsHeader extends StatelessWidget {
  final double totalEarned;
  final double pending;

  const CgEarningsHeader({
    super.key,
    required this.totalEarned,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.attach_money,
          label: 'Total Earned',
          value: '${totalEarned.toStringAsFixed(2)}',
          color: const Color(0xFF3A8BD7),
        ),
        SizedBox(width: 12.w),
        _StatCard(
          icon: Icons.access_time,
          label: 'Pending',
          value: '${pending.toStringAsFixed(2)}',
          color: const Color(0xFF97CCFD),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20.r),
                SizedBox(width: 3.w),
                 Text(label, style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.white70)),
             ],
            ),
            SizedBox(height: 8.h,),
            Text(value, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 22.sp, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}