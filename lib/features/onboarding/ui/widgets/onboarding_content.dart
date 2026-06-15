import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          width: 128.w,
          height: 128.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
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

        SizedBox(height: 34.h),

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.bold.copyWith(
            fontSize: 30.sp,
            color: AppColors.onboardingTitle,
          ),
        ),

        SizedBox(height: 20.h),

        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 18.sp,
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
        size: 58.r,
        color: Colors.white,
      );
    }

    // fallback
    return SizedBox();
  }
}