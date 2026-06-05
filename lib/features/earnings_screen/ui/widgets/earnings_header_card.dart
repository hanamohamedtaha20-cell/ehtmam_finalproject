import 'package:flutter/material.dart';

class EarningsHeaderCard extends StatelessWidget {
  const EarningsHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF3D7FD1),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            "Total Earnings (March)",

            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "4,820",

            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}