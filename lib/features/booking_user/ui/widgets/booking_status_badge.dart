import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _statusBgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(fontFamily: "Arimo", fontSize: 11, fontWeight: FontWeight.bold, color: _statusColor),
      ),
    );
  }
}