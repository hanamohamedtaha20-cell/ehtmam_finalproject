import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF0F8)
        
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewerInfo(review: review),
          const SizedBox(height: 10),
          _ReviewComment(comment: review.comment),
          const SizedBox(height: 12),
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
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: _avatarBg,
          child: Text(_initials,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(review.reviewerName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 3),
              Row(
                children: [
                  ServiceTypeBadge(serviceType: review.serviceType),
                  const SizedBox(width: 6),
                  const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textLight),
                  const SizedBox(width: 3),
                  Text(DateFormat('yyyy-MM-dd').format(review.date),
                      style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (i) => Icon(
            i < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppColors.yellow,
            size: 15,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '"$comment"',
        style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.55),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isHelpful ? Color(0xffECFDF5) : Color(0xffECFDF5),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(isHelpful ? 'Helpful ✓' : 'Helpful',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onViewBooking,
          child: Row(
            children: const [
              Text('View Booking',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight)),
              SizedBox(width: 3),
              Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.textLight),
            ],
          ),
        ),
      ],
    );
  }
}