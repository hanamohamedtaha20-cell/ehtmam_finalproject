<<<<<<< HEAD:lib/features/home_screen/ui/screens/home_screen.dart
import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_us_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:ehtemam_final_project/features/profile2/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/home_content.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/custom_nav_bar.dart';

import '../../../requests_screen_user/ui/screens/requests_screen.dart';
=======
import '/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import '/features/home_screen/ui/widgets/home_content.dart';
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408:lib/features/home_screen/ui/home_screen.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
<<<<<<< HEAD:lib/features/home_screen/ui/screens/home_screen.dart
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    RequestsScreen(),
    BookingUsScreenScreen(),
    ProfileScreen(),
  ];

=======
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408:lib/features/home_screen/ui/home_screen.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
           HomeContent(),

          Positioned(
            top: 40,
            right:
            Directionality.of(context) == TextDirection.ltr ? 16 : null,
            left:
            Directionality.of(context) == TextDirection.rtl ? 16 : null,
            child: const LanguageSwitcher(),
          ),
        ],
      ),
    );
  }
}