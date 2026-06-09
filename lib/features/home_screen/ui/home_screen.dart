import '/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import '/features/home_screen/ui/widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required bool isGuest});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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