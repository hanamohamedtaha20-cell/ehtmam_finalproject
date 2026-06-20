import 'package:ehtemam_final_project/features/payment_cg/ui/screens/cg_payment_screen.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/screens/caregiver_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account_settings/ui/screens/account_settings_screen_careprovider.dart';
import '../../earnings_screen/ui/screens/earnings_screen.dart';
import '../../homescreen_caregiver/ui/screens/home_screen_caregiver.dart';
import '../../request_screen_caregiver/ui/screens/care_requests_screen.dart';
import '../manager/bottom_nav_bar_cubit.dart';
import '../manager/bottom_nav_bar_state.dart';

class CareGiverBottomNavScreen extends StatelessWidget {
  const CareGiverBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: const _CareGiverBottomNavView(),
    );
  }
}

class _CareGiverBottomNavView extends StatelessWidget {
  const _CareGiverBottomNavView();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    final List<Widget> screens = [
      const HcHomeScreen(),
      const CareRequestsScreen(),
      const CgPaymentScreen(),
      const CaregiverScreen(),
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
            Color.fromARGB(255, 144, 192, 242),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(
                  context: context,
                  state: state,
                  index: 0,
                  icon: Icons.grid_view_outlined,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  scale: s,
                ),
                navItem(
                  context: context,
                  state: state,
                  index: 1,
                  icon: Icons.work_outline_rounded,
                  selectedIcon: Icons.work_rounded,
                  label: 'Requests',
                  scale: s,
                ),
                navItem(
                  context: context,
                  state: state,
                  index: 2,
                  icon: Icons.attach_money_rounded,
                  selectedIcon: Icons.attach_money_rounded,
                  label: 'Wallet',
                  scale: s,
                ),
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
                color: isSelected ? Colors.white : Colors.transparent,
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
