import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  final String role;

  const RegisterHeader({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7EC4F0),
                Color(0xFF4A8BC3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A8BC3).withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '$role Register',
          textAlign: TextAlign.center,
          style: AppTextStyle.bold.copyWith(
            fontSize: 28,
            color: const Color(0xFF22304A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Documents Required',
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 12,
            color: const Color(0xFFFB2C36),
          ),
        ),
      ],
    );
  }
}