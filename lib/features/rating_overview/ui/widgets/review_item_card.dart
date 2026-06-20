import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../data/model/provider_review_model.dart';
import 'service_type_badge.dart';

class ReviewItemCard extends StatelessWidget {
  final ProviderReviewModel review;
  final bool isHelpful;
  final VoidCallback onHelpfulTap;
  final VoidCallback onViewBooking;

  const ReviewItemCard({
    super.key,
    required this.review,
    required this.isHelpful,
    required this.onHelpfulTap,
    required this.onViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEEF0F8)
        ),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(61, 0, 0, 0), blurRadius: 6.r, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewerInfo(review: review),
          SizedBox(height: 10.h),
          _ReviewComment(comment: review.comment),
          SizedBox(height: 12.h),
          _ReviewActions(
            isHelpful: isHelpful,
            onHelpfulTap: onHelpfulTap,
            onViewBooking: onViewBooking,
          ),
        ],
      ),
    );
  }
}

class _ReviewerInfo extends StatelessWidget {
  final ProviderReviewModel review;
  const _ReviewerInfo({required this.review});

  Color get _avatarBg {
    switch (review.serviceType) {
      case 'Pet Care': return AppColors.lightBlue;
      case 'Elderly Care': return AppColors.lightBlue;
      default: return AppColors.lightBlue;
    }
  }

  
  String get _initials {
    final parts = review.reviewerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final picUrl = review.reviewerProfilePicture;
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: _avatarBg,
          backgroundImage:
              (picUrl != null && picUrl.isNotEmpty) ? NetworkImage(picUrl) : null,
          child: (picUrl == null || picUrl.isEmpty)
              ? Text(_initials,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))
              : null,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(review.reviewerName,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              SizedBox(height: 3.h),
              Row(
                children: [
                  ServiceTypeBadge(serviceType: review.serviceType),
                  SizedBox(width: 6.w),
                  Icon(Icons.calendar_today_outlined, size: 11.r, color: AppColors.textLight),
                  SizedBox(width: 3.w),
                  Text(DateFormat('yyyy-MM-dd').format(review.date),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textLight)),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (i) => Icon(
            i < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppColors.yellow,
            size: 15.r,
          )),
        ),
      ],
    );
  }
}

class _ReviewComment extends StatelessWidget {
  final String comment;
  const _ReviewComment({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '"$comment"',
        style: TextStyle(fontSize: 13.sp, color: Color(0xFF555555), height: 1.55.h),
      ),
    );
  }
}

class _ReviewActions extends StatelessWidget {
  final bool isHelpful;
  final VoidCallback onHelpfulTap;
  final VoidCallback onViewBooking;

  const _ReviewActions({
    required this.isHelpful,
    required this.onHelpfulTap,
    required this.onViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onHelpfulTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isHelpful ? Color(0xffECFDF5) : Color(0xffECFDF5),
              borderRadius: BorderRadius.circular(99.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 14.r, color: AppColors.primary),
                SizedBox(width: 5.w),
                Text(isHelpful ? 'Helpful ✓' : 'Helpful',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ],
            ),
          ),
        ),
       
      ],
    );
  }
}