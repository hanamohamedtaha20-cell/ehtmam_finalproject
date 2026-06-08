import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:ehtemam_final_project/core/resources/app_images.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/language_chip.dart';
import '../../../../core/resources/skip_button.dart';
import '../../../splash/ui/widgets/next_button.dart';
import '../widgets/onboarding_background.dart';
import 'ob2.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                /// Skip
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SkipButton(),
                  ],
                ),

                const SizedBox(height: 40),


                /// LOGO
                Image.asset(
                  AppImages.logo2,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                /// 🔥 Welcome to (gradient + shadow + size 48)
                /// Welcome Text
                const Text(
                  "Welcome to\nEhtemam",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 48,
                    color: Color(0xFF326986),
                    shadows: [
                      Shadow(
                        color: Color(0x70000000),
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                /// Description
                 Text(
                  "Your Trusted platform for quality\ncare services - pet care, elderly\ncare, and child care all in one\nplace.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: AppColors.cardBlueStart,

                    shadows: [
                      Shadow(
                        color: Colors.black12.withOpacity(0.2),
                        offset: Offset(0, 6),
                        blurRadius: 2//
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguageChip(),
                  ],
                ),
                const SizedBox(height: 18),
                /// Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    _dot(false),
                    _dot(false),
                  ],
                ),


                const SizedBox(height: 18),

                NextButton(
                  text: 'Next',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen2(),
                      ),
                    );

                  },
                  withArrow: true,
                ),

                const SizedBox(height: 20),
           ],
            ),
          ),
        ),
      )
      );
    }}


  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryBlue
            : AppColors.indicatorInactive.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }