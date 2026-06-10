import 'package:flutter/material.dart';

import 'hc_stat_card.dart';

class HcStatsGrid extends StatelessWidget {
  final int requestsToday;
  final int earningsThisWeek;
  final double rating;
  final String activeHours;

  const HcStatsGrid({
    super.key,
    required this.requestsToday,
    required this.earningsThisWeek,
    required this.rating,
    required this.activeHours,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * s),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: HcStatCard(
                  icon: Icons.calendar_today_rounded,
                  iconColor: const Color(0xFF3A8BD7),
                  value: '$requestsToday',
                  label: 'Requests Today',
                ),
              ),
              SizedBox(width: 12 * s),
              Expanded(
                child: HcStatCard(
                  icon: Icons.attach_money_rounded,
                  iconColor: const Color(0xFFF5A623),
                  value: '$earningsThisWeek',
                  label: 'This Week',
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * s),
          Row(
            children: [
              Expanded(
                child: HcStatCard(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF5A623),
                  value: rating.toStringAsFixed(1),
                  label: 'Rating',
                ),
              ),
              SizedBox(width: 12 * s),
              Expanded(
                child: HcStatCard(
                  icon: Icons.schedule_rounded,
                  iconColor: const Color(0xFF4CAF50),
                  value: activeHours,
                  label: 'Active Hours',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
