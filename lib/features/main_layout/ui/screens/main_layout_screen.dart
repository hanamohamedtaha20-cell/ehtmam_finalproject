import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account_settings/ui/screens/account_settings_screen_user.dart';
import '../../../bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import '../../../bottom_nav_bar/manager/bottom_nav_bar_state.dart';
import '../../../bottom_nav_bar/ui/bottom_nav_bar.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const Center(child: Text('Home')),
      const Center(child: Text('Requests')),
      const Center(child: Text('Bookings')),
      const AccountSettingsScreen(),
    ];

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F8FC),
          body: screens[state.currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
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