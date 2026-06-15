import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;

  const BookingStatusBadge({super.key, required this.status});

  Color get _statusColor {
    switch (status) {
      case 'upcoming': return AppColors.blue;
      case 'completed': return AppColors.green;
      case 'cancelled': return Colors.redAccent;
      default: return AppColors.textLight;
    }
  }

  Color get _statusBgColor {
    switch (status) {
      case 'upcoming': return AppColors.lightBlue;
      case 'completed': return AppColors.lightGreen;
      case 'cancelled': return AppColors.lightPink;
      default: return AppColors.bg1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: _statusBgColor, borderRadius: BorderRadius.circular(20.r)),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, fontWeight: FontWeight.bold, color: _statusColor),
      ),
    );
  }
}