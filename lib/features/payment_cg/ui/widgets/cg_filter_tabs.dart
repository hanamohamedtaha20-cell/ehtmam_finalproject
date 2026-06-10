import 'package:flutter/material.dart';

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
                width: 100,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF3A8BD7) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12,
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