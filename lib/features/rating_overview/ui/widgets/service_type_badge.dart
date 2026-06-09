import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

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
      case 'House Cleaning': return Icons.cleaning_services_rounded;
      default: return Icons.miscellaneous_services_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 10, color: _fg),
          const SizedBox(width: 3),
          Text(serviceType,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _fg)),
        ],
      ),
    );
  }
}