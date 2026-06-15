import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CgFilterTabs extends StatelessWidget {
  final String selected;
  final Function(String) onFilter;

  const CgFilterTabs({
    super.key,
    required this.selected,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Completed', 'Pending'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selected == f;
          return  GestureDetector(
              onTap: () => onFilter(f),
              child: Container(
                width: 100.w,
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF3A8BD7) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            );
          
        }).toList(),
      ),
    );
  }
}