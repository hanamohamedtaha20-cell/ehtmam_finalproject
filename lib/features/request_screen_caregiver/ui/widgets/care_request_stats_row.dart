
import 'package:flutter/material.dart';

class RequestStatsRow extends StatelessWidget {
  const RequestStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// PENDING
        Expanded(
          child: _buildCard(
            count: "3",
            label: "Pending",
            color: const Color(0xFFFFC857),
          ),
        ),

        const SizedBox(width: 10),

        /// ACTIVE
        Expanded(
          child: _buildCard(
            count: "5",
            label: "Active",
            color: const Color(0xFF4A90E2),
          ),
        ),

        const SizedBox(width: 10),

        /// COMPLETED
        Expanded(
          child: _buildCard(
            count: "18",
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
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

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