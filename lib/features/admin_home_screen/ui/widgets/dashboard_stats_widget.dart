import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardStatsWidget extends StatelessWidget {
  final int totalUsers;
  final int totalProviders;
  final int activeBookings;

  const DashboardStatsWidget({
    super.key,
    required this.totalUsers,
    required this.totalProviders,
    required this.activeBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people_alt_outlined,
                  iconColor: const Color(0xFF4A90E2),
                  iconBg: const Color(0xFFE8F1FB),
                  value: _format(totalUsers),
                  label: 'Total Users',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  icon: Icons.work_outline_rounded,
                  iconColor: const Color(0xFF4A90E2),
                  iconBg: const Color(0xFFE8F1FB),
                  value: _format(totalProviders),
                  label: 'Providers',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.assignment_outlined,
                  iconColor: const Color(0xFFF5A623),
                  iconBg: const Color(0xFFFFF3E0),
                  value: _format(activeBookings),
                  label: 'Active Bookings',
                ),
              ),
              SizedBox(width: 12.w),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  String _format(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    }
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20.r, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
