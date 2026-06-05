import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

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
                  fontSize: 14,
                  color: isSelected ? AppColors.blue : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: 70,
                color: isSelected ? AppColors.blue : Colors.transparent,
              ),
            ],
          ),
        );
      })
          .expand((w) => [w, const SizedBox(width: 20)])
          .toList()
        ..removeLast(),
    );
  }
}