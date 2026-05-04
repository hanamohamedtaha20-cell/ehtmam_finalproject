import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BookingActionButtons extends StatelessWidget {
  final String status;

  const BookingActionButtons({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (status == 'upcoming') ...[
          _OutlineButton(label: "Cancel", color: Colors.redAccent, onTap: () {}),
          const SizedBox(width: 8),
          _FilledButton(
            label: "Track",
            color: AppColors.green,
            gradient: const LinearGradient(
              colors: [AppColors.green, Color.fromARGB(255, 228, 246, 225)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            onTap: () {},
          ),
        ],
        if (status == 'completed')
          _FilledButton(label: "Book Again", color: AppColors.blue, onTap: () {}),
        if (status == 'cancelled')
          _FilledButton(label: "Rebook", color: AppColors.orange, onTap: () {}),
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(fontFamily: "Arimo", fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Gradient? gradient;

  const _FilledButton({required this.label, required this.color, required this.onTap, this.gradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(fontFamily: "Arimo", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}