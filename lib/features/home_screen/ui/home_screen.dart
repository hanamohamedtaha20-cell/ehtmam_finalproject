import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:ehtemam_final_project/features/profile2/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/home_content.dart';
import '../../requests_screen/ui/screens/requests_screen.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/custom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    RequestsScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),

          Positioned(
            top: 40,
            right: Directionality.of(context) == TextDirection.ltr ? 16 : null,
            left: Directionality.of(context) == TextDirection.rtl ? 16 : null,
            child: LanguageSwitcher(),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
