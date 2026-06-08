import 'package:flutter/material.dart';
import '../../../../core/resources/app_images.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: 219,
      height: 210,
      fit: BoxFit.contain,
    );
  }
}