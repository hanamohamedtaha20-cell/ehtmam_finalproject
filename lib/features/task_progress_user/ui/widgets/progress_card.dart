import 'package:flutter/material.dart';
import 'status_chip.dart';

class ProgressCard extends StatelessWidget {
  final double progressValue;
  final String progressPercent;
  final int completedCount;
  final int totalCount;

  const ProgressCard({
    super.key,
    required this.progressValue,
    required this.progressPercent,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A8BD7), Color(0xFF5A9FE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Progress",
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Progress",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13,
                        color: Colors.white70),
                  ),
                  Text(
                    progressPercent,
                    style: const TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$completedCount/$totalCount tasks",
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12,
                        color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                StatusChip(
                  icon: Icons.circle,
                  text: "Caregiver is currently working",
                  iconColor: Color(0xFF4CAF50),
                ),
                SizedBox(height: 6),
                StatusChip(
                  icon: Icons.location_pin,
                  text: "Checked in at 09:00 AM",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xff00A63E)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}