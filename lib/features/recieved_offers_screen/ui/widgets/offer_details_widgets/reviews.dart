import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/reviews_data.dart';


class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                review.name, // 👈 بدل name
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xFFFCE7B2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 14.r, color: Colors.orange),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Text(
            review.date,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),

          SizedBox(height: 10.h),

          Text(
            review.review,
            style: TextStyle(
              fontSize: 13.sp,
              color: Color(0xFF4B5563),
              height: 1.4.h,
            ),
          ),
        ],
      ),
    );
  }
}