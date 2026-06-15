import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color.fromARGB(0, 58, 139, 215)),
      //   boxShadow: [
      //     BoxShadow(
      //         color: Color(0x1A000000),
      //         offset: Offset(0, 2),
      //         blurRadius: 4.r),
      //   ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 13.sp,
                  color: AppColors.textDark)),
          RatingStars(rating: rating, onChanged: onChanged, size: 22.r),
        ],
      ),
    );
  }
}