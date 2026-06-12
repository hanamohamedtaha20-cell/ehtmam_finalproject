import 'package:flutter/material.dart';

class AdUserStatsCard extends StatelessWidget {
  final int total;

  const AdUserStatsCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            total.toString(),
            style: const TextStyle(
              color: Color(0xff2F93E6),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Total Users',
            style: TextStyle(
              color: Color(0xff111827),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}