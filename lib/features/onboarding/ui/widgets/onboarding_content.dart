import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_text_style.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;

  final IconData? icon;
  final String? imagePath;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue,
                AppColors.lightBlue,
              ],
            ),
          ),
          child: Center(
            child: _buildContent(),
          ),
        ),

        const SizedBox(height: 34),

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.bold.copyWith(
            fontSize: 30,
            color: AppColors.onboardingTitle,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 18,
            color: AppColors.cardBlueStart,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    // لو في image
    if (imagePath != null) {
      return Image.asset(
        imagePath!,

      );
    }

    // لو في icon
    if (icon != null) {
      return Icon(
        icon,
        size: 58,
        color: Colors.white,
      );
    }

    // fallback
    return const SizedBox();
  }
}