import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF3A8BD7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BigScore(summary: summary),
              const SizedBox(width: 20),
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
         const SizedBox(height: 12),
Divider(
  color: Colors.white.withOpacity(0.3),
  thickness: 1,
  height: 1,
),
const SizedBox(height: 12),
_SummaryStatRow(summary: summary),
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
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(5, (i) {
            final full = i < summary.averageRating.floor();
            final half = !full && i < summary.averageRating;
            return Icon(
              half ? Icons.star_half_rounded : Icons.star_rounded,
              color: full || half ? Color(0xFFFF7E22) : const Color.fromARGB(0, 255, 255, 255),
              size: 18,
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          '${summary.totalReviews} Reviews',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
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
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
              children: [
                Text(
                  '$star',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.star_rounded, color: AppColors.yellow, size: 12),
                const SizedBox(width: 5),
                Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 9,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 12,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 11,
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
        const SizedBox(width: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
         color: Colors.transparent,        ),
        child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Icon(icon, color: Colors.white, size: 20),
                     const SizedBox(width: 5),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
               const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
        ),
    );
  }
}