import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,

      child: Container(
        height: 45,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF432DD7).withOpacity(0.3),
              offset: const Offset(0, 6),
              blurRadius: 10,
            ),
          ],
          gradient: const LinearGradient(
            colors: [Color(0xFF3A8BD7), Color(0xFFD8E3E9)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
