import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewField extends StatelessWidget {
  final TextEditingController controller;

  const ReviewField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Write a Review (optional)",
            style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Share your feedback about the client, The app...",
            hintStyle: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 13,
                color: AppColors.textLight),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(fontFamily: "Arimo", fontSize: 13),
        ),
      ],
    );
  }
}