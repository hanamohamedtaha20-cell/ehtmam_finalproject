import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhyChooseUsCard extends StatelessWidget {
  const WhyChooseUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      "Save up to 40%",
      "No booking fees",
      "Priority scheduling",
      "Flexible cancellation",
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F80ED),
            Color(0xFF1C6DD0),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: Colors.white,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "Why Choose Bundles?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (_, index) {
              return Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16.r,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      features[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}