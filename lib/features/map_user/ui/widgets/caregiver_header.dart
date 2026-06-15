import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaregiverHeader extends StatelessWidget {
  final String name;
  final String speciality;
  final String rating;
  final String reviewCount;

  const CaregiverHeader({
    super.key,
    required this.name,
    required this.speciality,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 30.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black)),
              Text(speciality,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: Colors.black45)),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.r),
                  SizedBox(width: 4.w),
                  Text(
                    "$rating ($reviewCount reviews)",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12.sp,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}