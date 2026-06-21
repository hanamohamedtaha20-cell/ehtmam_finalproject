import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientHeader extends StatelessWidget {
  final String name;
  final String serviceType;
  final double clientRating;

  const ClientHeader({
    super.key,
    required this.name,
    required this.serviceType,
    this.clientRating = 0,
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
              Text(name, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black)),
              Text(serviceType, style: TextStyle(fontFamily: "Arimo", fontSize: 14.sp, color: Colors.black87)),
              SizedBox(height: 2.h),
              if (clientRating > 0)
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 14.r),
                    SizedBox(width: 3.w),
                    Text(
                      clientRating.toStringAsFixed(1),
                      style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.black87),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 14.r),
                    SizedBox(width: 3.w),
                    Text('no_ratings_yet'.tr(),
                      style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.grey),
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