import 'package:flutter/material.dart';
import '../../../../core/resources/app_text_style.dart';

class LanguageChip extends StatelessWidget {
  const LanguageChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.language,
            size: 16,
            color: Color(0xFF5C6B82),
          ),
          const SizedBox(width: 6),
          Text(
            'العربية',
            style: AppTextStyle.medium.copyWith(
              fontSize: 13,
              color: const Color(0xFF5C6B82),
            ),
          ),
        ],
      ),
    );
  }
}