import 'package:flutter/material.dart';

class RequestStatsRow extends StatelessWidget {
  final int pendingCount;
  final int activeCount;
  final int completedCount;

  const RequestStatsRow({
    super.key,
    this.pendingCount = 0,
    this.activeCount = 0,
    this.completedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            count: pendingCount.toString(),
            label: "Pending",
            color: const Color(0xFFFFC857),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCard(
            count: activeCount.toString(),
            label: "Active",
            color: const Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCard(
            count: completedCount.toString(),
            label: "Completed",
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
