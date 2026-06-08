import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

    const StatusChip({
      super.key,
      required this.icon,
      required this.text,
      this.iconColor = const Color(0xFF3A8BD7),
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Icon(icon, color: iconColor, size: 16),        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
              fontFamily: "Arimo", fontSize: 12, color: Color(0xFF3A8BD7)),
        ),
      ],
    );
  }
}