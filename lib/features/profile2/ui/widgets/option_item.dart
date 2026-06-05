import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isGradient; // ← أضفنا دي

  const OptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.isGradient = false, // ← default false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isGradient ? null : color, // ← لو gradient متحطش color
                gradient: isGradient
                    ? LinearGradient(
                        colors: [color, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: Colors.white), // ← بدلنا لـ white
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontFamily: "Arimo", fontSize: 14, color: AppColors.textDark)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}