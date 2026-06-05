import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account_settings/ui/screens/account_settings_screen_careprovider.dart';
import '../manager/bottom_nav_bar_cubit.dart';
import '../manager/bottom_nav_bar_state.dart';
class CareGiverBottomNavScreen extends StatelessWidget {
  const CareGiverBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    final List<Widget> screens = [
      const Center(child: Text('Dashboard')),
      const Center(child: Text('Requests')),
      const Center(child: Text('Earnings')),
      const CareProviderAccountSettingsScreen(),
    ];

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,

          body: screens[state.currentIndex],

          bottomNavigationBar: Container(
            height: 88 * s,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF3A8BD7),
                  Color(0xFFEAF4FF),
                ],
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                // DASHBOARD
                navItem(
                  context: context,
                  state: state,
                  index: 0,
                  icon: Icons.grid_view_outlined,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  scale: s,
                ),

                // REQUESTS
                navItem(
                  context: context,
                  state: state,
                  index: 1,
                  icon: Icons.work_outline_rounded,
                  selectedIcon: Icons.work_rounded,
                  label: 'Requests',
                  scale: s,
                ),

                // EARNINGS
                navItem(
                  context: context,
                  state: state,
                  index: 2,
                  icon: Icons.attach_money_rounded,
                  selectedIcon: Icons.attach_money_rounded,
                  label: 'Earnings',
                  scale: s,
                ),

                // PROFILE
                navItem(
                  context: context,
                  state: state,
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profile',
                  scale: s,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget navItem({
    required BuildContext context,
    required BottomNavState state,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required double scale,
  }) {
    final bool isSelected = state.currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        context.read<BottomNavCubit>().changeTab(index);
      },

      child: SizedBox(
        width: 80 * scale,
        height: 88 * scale,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // BLUE TOP LINE
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              width: isSelected ? 36 * scale : 0,
              height: 4 * scale,

              decoration: BoxDecoration(
                color: const Color(0xFF3A8BD7),

                borderRadius: BorderRadius.circular(20),
              ),
            ),

            SizedBox(height: 8 * scale),

            // ICON CIRCLE
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              width: isSelected ? 38 * scale : 26 * scale,
              height: isSelected ? 38 * scale : 26 * scale,

              decoration: BoxDecoration(
                color:
                isSelected ? Colors.white : Colors.transparent,

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

            SizedBox(height: 6 * scale),

            // LABEL
            Text(
              label,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12 * scale,
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