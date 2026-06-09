import 'package:ehtmam_finalproject/features/home_screen/ui/home_screen.dart';
import 'package:ehtmam_finalproject/features/requests_screen/ui/screens/requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account_settings/ui/screens/account_settings_screen_user.dart';
import '../../../bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import '../../../bottom_nav_bar/manager/bottom_nav_bar_state.dart';
import '../../../bottom_nav_bar/ui/bottom_nav_bar.dart';

class MainLayoutScreen extends StatelessWidget {
  final bool isGuest;

  const MainLayoutScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(isGuest: isGuest),
      const RequestsScreen(),
      const Center(child: Text('Bookings')),
      AccountSettingsScreen(),
    ];

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F8FC),
          body: screens[state.currentIndex],
          bottomNavigationBar: UserBottomNavScreen(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<BottomNavCubit>().changeTab(index);
            },
          ),
        );
      },
    );
  }
}