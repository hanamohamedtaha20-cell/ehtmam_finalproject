import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

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
  height: 40,
  color: Colors.white,
  child: ListView(
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    padding: const EdgeInsets.symmetric(horizontal: 10),
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
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xff3A8BD7) : Colors.white,
            borderRadius: BorderRadius.circular(99),
           
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label == 'All') ...[
                Icon(
                  Icons.filter_list_rounded,
                  size: 14,
                  color: isActive ? Colors.white : AppColors.textLight,
                ),
                const SizedBox(width: 2),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textLight,
                    ),
                  ),
            if (showStar) ...[
              const SizedBox(width: 1),
              const Icon(Icons.star_rounded, color: AppColors.yellow, size: 13),
            ],
          ],
        ),
      ),
    );
  }
}