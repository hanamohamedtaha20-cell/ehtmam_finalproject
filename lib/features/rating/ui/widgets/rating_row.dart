import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_stars.dart';
import 'package:flutter/material.dart';

class RatingRow extends StatelessWidget {
  final String label;
  final int rating;
  final ValueChanged<int> onChanged;

  const RatingRow({
    super.key,
    required this.label,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      //   boxShadow: const [
      //     BoxShadow(
      //         color: Color(0x1A000000),
      //         offset: Offset(0, 2),
      //         blurRadius: 4),
      //   ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 13,
                  color: AppColors.textDark)),
          RatingStars(rating: rating, onChanged: onChanged, size: 22),
        ],
      ),
    );
  }
}