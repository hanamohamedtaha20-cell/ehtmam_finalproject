import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_us_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/home_content.dart';
import '../../../requests_screen_user/ui/screens/requests_screen.dart';



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
    BookingUsScreenScreen(),
    ProfileScreen(),
  ];

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