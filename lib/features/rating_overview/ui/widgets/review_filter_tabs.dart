import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewFilterTabs extends StatelessWidget {
  final int? activeFilter;
  final ValueChanged<int?> onFilterChanged;

  const ReviewFilterTabs({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  height: 40.h,
  color: Colors.white,
  child: ListView(
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(horizontal: 10.w),
        children: [
          _FilterChip(
            label: 'All',
            isActive: activeFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          ...[5, 4, 3, 2, 1].map((star) => _FilterChip(
                label: '$star',
                showStar: true,
                isActive: activeFilter == star,
                onTap: () => onFilterChanged(star),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool showStar;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.showStar = false,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Color(0xff3A8BD7) : Colors.white,
            borderRadius: BorderRadius.circular(99.r),
           
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label == 'All') ...[
                Icon(
                  Icons.filter_list_rounded,
                  size: 14.r,
                  color: isActive ? Colors.white : AppColors.textLight,
                ),
                SizedBox(width: 2.w),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textLight,
                    ),
                  ),
            if (showStar) ...[
              SizedBox(width: 1.w),
              Icon(Icons.star_rounded, color: AppColors.yellow, size: 13.r),
            ],
          ],
        ),
      ),
    );
  }
}