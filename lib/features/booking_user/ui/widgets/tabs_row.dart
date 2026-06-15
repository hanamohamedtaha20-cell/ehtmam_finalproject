import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabsRow extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const TabsRow({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Upcoming", "Completed", "Cancelled"];
    return Row(
      children: List.generate(tabs.length, (i) {
        final isSelected = selectedIndex == i;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Column(
            children: [
              Text(
                tabs[i],
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14.sp,
                  color: isSelected ? AppColors.blue : AppColors.textLight,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 2.h,
                width: 70.w,
                color: isSelected ? AppColors.blue : Colors.transparent,
              ),
            ],
          ),
        );
      })
          .expand((w) => [w, SizedBox(width: 20.w)])
          .toList()
        ..removeLast(),
    );
  }
}