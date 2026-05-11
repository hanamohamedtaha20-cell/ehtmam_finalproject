import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3A8BD7),
            Color(0xFFD8EAF8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              _navItem(Icons.home_outlined, 'Home'.tr(), 0),
              _navItem(Icons.description_outlined, 'Requests'.tr(), 1),
              _navItem(Icons.calendar_month_outlined, 'Booking'.tr(), 2),
              _navItem(Icons.person_outline_rounded, 'Profile'.tr(), 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// الخط الأزرق فوق
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: 32,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1E5BFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            /// الأيقونة
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.85)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF3A8BD7)
                    : Colors.white,
              ),
            ),

            const SizedBox(height: 2),

            /// النص
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}