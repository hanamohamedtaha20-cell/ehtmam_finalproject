import 'package:ehtemam_final_project/core/resources/language_chip.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/register_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/select_role_card.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/select_role_logo_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../onboarding/ui/widgets/onboarding_background.dart';
import '../../../../core/resources/app_text_style.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              children: [
                const SelectRoleLogoSection(),

                SizedBox(height: 34.h),

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

                SizedBox(height: 18.h),

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

                SizedBox(height: 14.h),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:  Text(
                    'Back to Login',
                    style: AppTextStyle.bold.copyWith(
                      fontSize: 16.sp,
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