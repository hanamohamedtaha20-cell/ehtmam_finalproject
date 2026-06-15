import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin_features/ui/screens/bundles_screen.dart';
import '../../../admin_home_screen/ui/screens/admin_dashboard._screen.dart';
import '../../../admin_provider_screen/ui/screens/ad_provider_screen.dart';
import '../../../admin_users_screen/ui/ad_user_screen.dart';
import '../../manager/bottom_nav_bar_cubit.dart';
import '../../manager/bottom_nav_bar_state.dart';

class AdminButtomNavBar extends StatelessWidget {
  const AdminButtomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    final List<Widget> screens = [
      AdminDashboardScreen(),
      AdUserScreen(),
      AdProviderScreen(),
      //PendingApprovalsScreen()
      BundlesScreen()

    ];

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,

          body: screens[state.currentIndex],

          bottomNavigationBar: Container(
            height: 88.h,

            decoration: BoxDecoration(
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
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  scale: s,
                ),

                // REQUESTS
                navItem(
                  context: context,
                  state: state,
                  index: 1,
                  icon: Icons.people_alt_outlined,
                  selectedIcon: Icons.people_alt_rounded,
                  label: 'Users',
                  scale: s,
                ),

                // EARNINGS
                navItem(
                  context: context,
                  state: state,
                  index: 2,
                  icon: Icons.business_center_outlined,
                  selectedIcon: Icons.business_center_rounded,
                  label: 'Providers',
                  scale: s,
                ),

                // PROFILE
                navItem(
                  context: context,
                  state: state,
                  index: 3,
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'Settings',
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
        width: 80.w * scale,
        height: 88.h * scale,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // BLUE TOP LINE
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

            SizedBox(height: 6.h * scale),

            // LABEL
            Text(
              label,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

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