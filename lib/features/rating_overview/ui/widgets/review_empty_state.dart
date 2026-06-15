import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final bool isError;
  final VoidCallback? onRetry;

  const ReviewEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.rate_review_outlined,
    this.isError = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: isError ? AppColors.lightPink : AppColors.lightPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36.r, color: isError ? Colors.redAccent : AppColors.primary),
            ),
            SizedBox(height: 16.h),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textLight, height: 1.5.h)),
            if (isError && onRetry != null) ...[
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, size: 16.r),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99.r)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}