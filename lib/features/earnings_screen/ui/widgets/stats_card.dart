import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String value;
  final String title;
  final Color color;

  const StatsCard({
    super.key,
    required this.value,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset:  Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            decoration: BoxDecoration(
              color: color.withOpacity(0.18),

              borderRadius:
              BorderRadius.circular(18),

              boxShadow: [
                BoxShadow(
                  color:
                  color.withOpacity(0.2),
                  blurRadius: 8,
                  offset:  Offset(0, 6),
                ),
              ],
            ),

      child: Text(
        value,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
       ),
          ),

          const SizedBox(height: 14),

          Text(
            title,

            style: TextStyle(
              color: const Color(0xFF475467),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}