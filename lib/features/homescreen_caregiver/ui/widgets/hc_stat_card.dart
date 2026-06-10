import 'package:flutter/material.dart';

class HcStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const HcStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Container(
      padding: EdgeInsets.all(14 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * s),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36 * s,
            height: 36 * s,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10 * s),
            ),
            child: Icon(icon, color: Colors.white, size: 18 * s),
          ),
          SizedBox(height: 12 * s),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24 * s,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B2B5A),
            ),
          ),
          SizedBox(height: 2 * s),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12 * s,
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}
