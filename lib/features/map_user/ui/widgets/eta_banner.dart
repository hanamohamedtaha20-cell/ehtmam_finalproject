import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ETABanner extends StatelessWidget {
  final String eta;
  final String distance;

  const ETABanner({
    super.key,
    required this.eta,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.all(18.r),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF3A8BD7),
        Color(0xFF97CCFD),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
            Icon(Icons.circle, color: Colors.white, size: 10.r),
            SizedBox(width: 3.w),
              Text(
                "Live Location Tracking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),  ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ETAItem(label: "Estimated Arrival", value: eta),
              Spacer(),
              _ETAItem(label: "Distance", value: distance),
            ],
          ),
        ],
      ),
    );
  }
}

class _ETAItem extends StatelessWidget {
  final String label;
  final String value;

  const _ETAItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Arimo",
            fontSize: 11.sp,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            color: Colors.white,
          ),
        ),
        
      ],
    );
  }
}