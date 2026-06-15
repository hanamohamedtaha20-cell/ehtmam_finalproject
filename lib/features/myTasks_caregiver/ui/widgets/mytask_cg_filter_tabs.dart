import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MytaskCgFilterTabs extends StatelessWidget {
  final String selected;
  final int allCount;
  final int pendingCount;
  final int doneCount;
  final Function(String) onFilter;

  const MytaskCgFilterTabs({
    super.key,
    required this.selected,
    required this.allCount,
    required this.pendingCount,
    required this.doneCount,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
  children: [
    Expanded(
      child: _FilterChip(label: 'All ($allCount)', value: 'all', selected: selected, onTap: onFilter),
    ),
    Expanded(
      child: _FilterChip(label: 'Pending ($pendingCount)', value: 'pending', selected: selected, onTap: onFilter),
    ),
    Expanded(
      child: _FilterChip(label: 'Done ($doneCount)', value: 'done', selected: selected, onTap: onFilter),
    ),
  ],
);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final Function(String) onTap;

  const _FilterChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? Border.all(color: const Color(0xFF1976D2)) : null,
        ),
        child: Center(
          child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                Icon(Icons.filter_alt_outlined, size: 14.r, color: Color(0xFF1976D2)),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1976D2) : Color(0xFF45556C),
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}