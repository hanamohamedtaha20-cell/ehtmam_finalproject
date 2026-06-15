import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCardWidget extends StatelessWidget {
  final Widget icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final List<Color> gradientBGColors;
  final Widget page;

  const ServiceCardWidget({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.gradientBGColors,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),

      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },

        child: Container(
          margin:  EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: 8.w,
          ),

          padding: EdgeInsets.all(16.r),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientBGColors,
            ),

            borderRadius: BorderRadius.circular(24.r),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6.r,
                offset:  Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // Icon Box
              Container(
                width: 60.w,
                height: 60.h,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),

                child: Center(child: icon),
              ),

              SizedBox(width: 16.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C2E),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      subtitle,

                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        height: 1.3.h,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.r,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}