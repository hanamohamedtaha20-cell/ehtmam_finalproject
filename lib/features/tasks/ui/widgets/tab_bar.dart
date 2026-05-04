import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class TaskTabs extends StatelessWidget {
  final int selectedIndex;
  final int allCount;
  final int activeCount;
  final int completedCount;
  final ValueChanged<int> onTap;

  const TaskTabs({
    super.key,
    required this.selectedIndex,
    required this.allCount,
    required this.activeCount,
    required this.completedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(label: "All Tasks ($allCount)", selected: selectedIndex == 0, onTap: () => onTap(0)),
        const SizedBox(width: 8),
        _Tab(label: "Active ($activeCount)", selected: selectedIndex == 1, onTap: () => onTap(1)),
        const SizedBox(width: 8),
        _Tab(label: "Completed ($completedCount)", selected: selectedIndex == 2, onTap: () => onTap(2)),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: "Arimo",
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: selected ? AppColors.lightBlue : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}