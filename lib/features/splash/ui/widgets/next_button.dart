import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool withArrow;
  final double radius;

  const NextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.withArrow = false,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.r),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2F7FCD),
              Color(0xFF2F7FCD),
              Color(0x99FFFFFF),
            ],
            stops: [0.0, 0.58, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              if (withArrow) ...[
                SizedBox(width: 6.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14.r,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
