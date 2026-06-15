import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashIndicator extends StatelessWidget {
  const SplashIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }
}