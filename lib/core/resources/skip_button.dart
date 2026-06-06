import 'package:flutter/material.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import 'app_colors.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },

          child: Text(
            "Skip →",
            style: TextStyle(
              color: Color(0xFF7C889C),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}