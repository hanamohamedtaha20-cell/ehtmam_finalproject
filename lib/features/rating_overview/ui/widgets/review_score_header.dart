import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_review_model.dart';

class ReviewScoreHeader extends StatelessWidget {
  final ProviderReviewSummaryModel summary;
  final int? activeStarFilter;
final ValueChanged<int?> onFilterChanged;
  const ReviewScoreHeader({
    super.key,
    required this.summary,
    required this.activeStarFilter,
    required this.onFilterChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.r),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Color(0xFF3A8BD7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BigScore(summary: summary),
              SizedBox(width: 20.w),
              Expanded(
              child: _StarFilterBars(
                starCounts: summary.starCounts,
                total: summary.totalReviews,
                activeStarFilter: activeStarFilter,
                onFilterChanged: onFilterChanged,
              ),
            ),
             ],
          ),
         SizedBox(height: 12.h),
          
                  ],
                ),
              );
            }
          }

class _BigScore extends StatelessWidget {
  final ProviderReviewSummaryModel summary;
  const _BigScore({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center
      ,
      children: [
        Text(
          summary.averageRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 52.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.h,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: List.generate(5, (i) {
            final full = i < summary.averageRating.floor();
            final half = !full && i < summary.averageRating;
            return Icon(
              half ? Icons.star_half_rounded : Icons.star_rounded,
              color: full || half ? Color(0xFFFF7E22) : const Color.fromARGB(0, 255, 255, 255),
              size: 18.r,
            );
          }),
        ),
        SizedBox(height: 4.h),
        Text(
          '${summary.totalReviews} Reviews',
          style: TextStyle(fontSize: 12.sp, color: Colors.white70),
        ),
      ],
    );
  }
}

class _StarFilterBars extends StatelessWidget {
  final Map<int, int> starCounts;
  final int total;
  final int? activeStarFilter;
  final ValueChanged<int?> onFilterChanged;

  const _StarFilterBars({
    required this.starCounts,
    required this.total,
    required this.activeStarFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [5, 4, 3, 2, 1].map((star) {
        final count = starCounts[star] ?? 0;
        final fraction = total == 0 ? 0.0 : count / total;

        return  Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
              children: [
                Text(
                  '$star',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 3.w),
                Icon(Icons.star_rounded, color: AppColors.yellow, size: 12.r),
                SizedBox(width: 5.w),
                Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99.r),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 9,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              SizedBox(
                width: 12.w,
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ]),
              
        );
      }).toList(),
      
    );
  }
}
  
class _SummaryStatRow extends StatelessWidget {
  final ProviderReviewSummaryModel summary;
  const _SummaryStatRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          icon: Icons.trending_up_rounded,
          value: '${summary.positivePercentage}%',
          label: 'Positive',
        ),
        SizedBox(width: 12.w),
        _StatChip(
          icon: Icons.workspace_premium_rounded,
          value: 'Top ${summary.providerRankPercentage}%',
          label: 'Provider Rank',
        ),
      ],
    );
    
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
         color: Colors.transparent,        ),
        child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w),
                    Icon(icon, color: Colors.white, size: 20.r),
                     SizedBox(width: 5.w),
                    Text(value,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
               SizedBox(height: 4.h),
                Text(label,
                    style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
              ],
            ),
        ),
    );
  }
}