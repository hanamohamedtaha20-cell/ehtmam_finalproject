import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const PrimaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF432DD7).withOpacity(0.3),
              offset: Offset(0, 6),
              blurRadius: 10,
            ),
          ],
          gradient: LinearGradient(
            colors: [Color(0xFF3A8BD7), Color(0xFFD8E3E9)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
