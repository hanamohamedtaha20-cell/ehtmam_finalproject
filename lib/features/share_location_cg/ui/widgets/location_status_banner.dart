import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationStatusBanner extends StatelessWidget {
  final String eta;
  final String distance;
  final bool isSharing;

  const LocationStatusBanner({
    super.key,
    required this.eta,
    required this.distance,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.all(18.r),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3A8BD7), Color(0xFF97CCFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: isSharing ? Colors.greenAccent : Colors.white54, size: 10.r),
              SizedBox(width: 3.w),
              Text(
                isSharing ? "Location Sharing Active" : "Location Sharing Inactive",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            "Start sharing your location to let the client track your arrival"
              ,style: TextStyle(color: Colors.white70, fontSize: 14.sp),

          )
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  const _Item({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Colors.white70)),
        Text(value, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 22.sp, color: Colors.white)),
      ],
    );
  }
}