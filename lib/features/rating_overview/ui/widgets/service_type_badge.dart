import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceTypeBadge extends StatelessWidget {
  final String serviceType;
  const ServiceTypeBadge({super.key, required this.serviceType});

  

  Color get _fg {
    switch (serviceType) {
      case 'Pet Care': return AppColors.green;
      case 'Elderly Care': return AppColors.green;
      default: return AppColors.green;
    }
  }

  IconData get _icon {
    switch (serviceType) {
      case 'Pet Care': return Icons.pets_rounded;
      case 'Elderly Care': return Icons.elderly_rounded;
      default: return Icons.miscellaneous_services_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(99.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 10.r, color: _fg),
          SizedBox(width: 3.w),
          Text(serviceType,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: _fg)),
        ],
      ),
    );
  }
}