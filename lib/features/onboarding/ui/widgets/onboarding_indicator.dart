import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) {
          final bool isActive = index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: isActive ? 18 : 8,
            height: 8.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.indicatorInactive
                  : AppColors.indicatorInactive.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }
}