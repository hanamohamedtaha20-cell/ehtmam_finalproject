import 'package:ehtmam_finalproject/features/auth/ui/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/language_chip.dart';
import 'package:ehtmam_finalproject/features/onboarding/ui/widgets/onboarding_background.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/select_role_card.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/select_role_logo_section.dart';

import '../../../../core/resources/app_text_style.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: LanguageChip(),
                ),
                const SizedBox(height: 26),

                const SelectRoleLogoSection(),

                const SizedBox(height: 34),

                SelectRoleCard(
                  title: 'User',
                  description:
                  'Request care services\nfor your loved ones',
                  icon: Icons.person_outline_outlined,
                  iconBackgroundColor:  Color(0xFF3A8BD7),
                  cardColor:  Color(0xFFF3F6FA),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(role: 'User'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                SelectRoleCard(
                  title: 'Care giver',
                  description:
                  'Offer care services and\nhelp families',
                 imagePath: 'assets/images/heart_icon.png',
                  iconBackgroundColor: Color(0xFF97CCFD),
                  cardColor: Color(0xFFF3F6FA),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(role: 'Care giver'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:  Text(
                    'Back to Login',
                    style: AppTextStyle.bold.copyWith(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}