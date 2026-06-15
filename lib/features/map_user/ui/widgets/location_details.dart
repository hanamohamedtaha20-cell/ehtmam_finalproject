import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationDetails extends StatelessWidget {
  final String userLocation;
  final String caregiverLocation;
  final String distance;
  final String eta;

  const LocationDetails({
    super.key,
    required this.userLocation,
    required this.caregiverLocation,
    required this.distance,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(16.0.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            blurRadius: 6.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
        child: Column(
          children: [
            _LocationRow(
              icon: Icons.location_on,
              iconColor: const Color(0xFF3A8BD7),
              title: "Your Location",
              subtitle: userLocation,
            ),
            SizedBox(height: 12.h),
            _LocationRow(
              icon: Icons.person_pin_circle,
              iconColor: Colors.green,
              title: "Caregiver's Current Location",
              distance: "$distance • $eta",
            ),
          ],
        ),
      );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? distance;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.title,
     this.subtitle,
     this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22.r),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Colors.black,
                ),
              ),
              if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
               if (distance != null)
              Text(
                distance!,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}