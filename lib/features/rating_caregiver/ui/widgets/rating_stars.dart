import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: const Color(0xFFFFC107),
              size: size,
            ),
          ),
        );
      }),
    );
  }
}