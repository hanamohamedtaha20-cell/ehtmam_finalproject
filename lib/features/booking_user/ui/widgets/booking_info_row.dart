import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const BookingInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.blue), // 👈 blue icon
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 12,
                color: AppColors.textDark)), // 👈 dark text
      ],
    );
  }
}