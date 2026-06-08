import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/material.dart';

class ContactInfoCard extends StatelessWidget {
  final CaregiverModel profile;

  const ContactInfoCard({super.key, required this.profile});

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
          const Text("CONTACT INFORMATION",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                  letterSpacing: 2)),
           SizedBox(height: 16),
          _InfoRow(icon: Icons.phone_outlined, text: profile.phone, color: AppColors.blue),
           SizedBox(height: 24),
          _InfoRow(icon: Icons.email_outlined, text: profile.email, color: AppColors.blue),
          SizedBox(height: 24),
          _InfoRow(icon: Icons.location_on_outlined, text: profile.location, color: Color(0xFF7F22FE)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Text(text,
            style: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 13,
                color: AppColors.textDark)),
      ],
    );
  }
}