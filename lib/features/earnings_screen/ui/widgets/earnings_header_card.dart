import 'package:flutter/material.dart';

class EarningsHeaderCard extends StatelessWidget {
  const EarningsHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 25,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            "Total Earnings",

            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "4,820",

            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius:
              BorderRadius.circular(20),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 12,
                ),

                SizedBox(width: 4),

                Text(
                  "+15.3% from last month",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}