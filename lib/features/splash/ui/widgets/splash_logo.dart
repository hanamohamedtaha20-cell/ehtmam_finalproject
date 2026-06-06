import 'package:flutter/material.dart';
import '../../../../core/resources/app_images.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: 319,
      height: 310,
      fit: BoxFit.contain,
    );
  }
}