import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/material.dart';

class PerformanceCard extends StatelessWidget {
  final CaregiverModel profile;

  const PerformanceCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 245, 249),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PERFORMANCE",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                  letterSpacing: 2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatBox(value: profile.totalRequests.toString(), label: "Total Requests", bgColor: Color(0xFF00A6F4), textColor: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _StatBox(value: "${profile.totalEarnings}K", label: "Total Earnings", bgColor: Color(0xFF1F9E0E), textColor:Colors.white )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatBox(value: "${profile.completionRate.toInt()}%", label: "Completion Rate", bgColor: Color.fromARGB(255, 250, 234, 63), textColor: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _StatBox(value: profile.avgResponse, label: "Avg Response", bgColor: Color(0xFFE17100), textColor:Colors.white )),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color bgColor;
  final Color textColor;

  const _StatBox({
    required this.value,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,  // 👈 small fixed width
          height: 60, // 👈 small fixed height
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: textColor)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, // 👈 label outside the box
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 11,
                color: AppColors.textLight)),
      ],
    );
  }
}