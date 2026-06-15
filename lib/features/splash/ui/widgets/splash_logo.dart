import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_images.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: 219.w,
      height: 210.h,
      fit: BoxFit.contain,
    );
  }
}