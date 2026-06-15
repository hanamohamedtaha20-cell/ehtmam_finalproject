import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserBottomNavScreen extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNavScreen({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF3A8BD7),
            Color.fromARGB(255, 144, 192, 242),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(
            index: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
            scale: s,
          ),

          navItem(
            index: 1,
            icon: Icons.description_outlined,
            selectedIcon: Icons.description_rounded,
            label: 'Requests',
            scale: s,
          ),

          navItem(
            index: 2,
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month_rounded,
            label: 'Booking',
            scale: s,
          ),

          navItem(
            index: 3,
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
            scale: s,
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required double scale,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        onTap(index);
      },

      child: SizedBox(
        width: 80.w * scale,
        height: 88.h * scale,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 36 * scale : 0,
              height: 4.h * scale,
              decoration: BoxDecoration(
                color: const Color(0xFF3A8BD7),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            SizedBox(height: 8.h * scale),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 38 * scale : 26 * scale,
              height: isSelected ? 38 * scale : 26 * scale,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: isSelected ? 21 * scale : 19 * scale,
                color: isSelected
                    ? const Color(0xFF3A8BD7)
                    : Colors.white,
              ),
            ),

            SizedBox(height: 6.h * scale),

            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp * scale,
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