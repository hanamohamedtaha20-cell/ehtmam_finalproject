import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onConfirm;

  const ActionButtons({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: const Center(
                child: Text("Cancel",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.purple, AppColors.purple2]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
                ],
              ),
              child: const Center(
                child: Text("Confirm",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}