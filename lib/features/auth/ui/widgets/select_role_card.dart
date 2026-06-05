import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/app_text_style.dart';

class SelectRoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Color iconBackgroundColor;
  final Color cardColor;
  final VoidCallback onTap;
  final String? imagePath;

  const SelectRoleCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    required this.iconBackgroundColor,
    required this.cardColor,
    required this.onTap,
    this.imagePath,

  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconBackgroundColor.withOpacity(0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  width: 5,
                  height: 5,
                  //fit: BoxFit.contain,
                )
                    : Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bold.copyWith(
                        fontSize: 18,
                        color: const Color(0xFF1D293D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 16,
                        height: 1.35,
                        color: const Color(0xFF506177),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(0xFF8B98AA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}