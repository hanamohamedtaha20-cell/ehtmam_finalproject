import 'package:flutter/material.dart';
import 'hc_stat_card.dart';

class HcStatsGrid extends StatelessWidget {
  const HcStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.18,
      children: const [
        HcStatCard(
          icon: Icons.calendar_month,
          value: '3',
          title: 'Requests Today',
          color: Color(0xff1687F3),
        ),
        HcStatCard(
          icon: Icons.attach_money,
          value: '8400',
          title: 'This Week',
          color: Color(0xffF5A333),
        ),
        HcStatCard(
          icon: Icons.star_border,
          value: '4.9',
          title: 'Rating',
          color: Color(0xffFF6B2C),
        ),
        HcStatCard(
          icon: Icons.access_time,
          value: '28h',
          title: 'Active Hours',
          color: Color(0xff16A34A),
        ),
      ],
    );
  }
}