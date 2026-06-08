import '../../../onboarding/ui/widgets/onboarding_background.dart';
import 'package:flutter/material.dart';
import '../../../onboarding/ui/widgets/onboarding_indicator.dart';
import '../../../../core/resources/app_fonts.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/language_chip.dart';
import '../../../../core/resources/skip_button.dart';
import '../../../auth/ui/screens/login_screen.dart';
import '../../../splash/ui/widgets/next_button.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});
  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 393).clamp(0.85, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);
    return Scaffold(
      body: OnboardingBackground(
        child: Container(
          width: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20 * s,
                vertical: 12 * s,
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SkipButton(),
                    ],
                  ),

                  SizedBox(height:60 ),

                  Container(
                    width: 128 * s,
                    height: 128 * s,
                    decoration: BoxDecoration(
                      color: const Color(0xFF97CCFD),
                      borderRadius: BorderRadius.circular(18 * s),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF3A8BD7),
                          offset: Offset(0, 25),
                          blurRadius: 50,
                          spreadRadius: -12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        AppImages.star,
                        width: 85,
                        height: 82,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 48 * s),

                  Text(
                    'Verified Providers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D293D),
                      shadows:  [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50),

                  Text(
                    'All our care providers are thoroughly\nvetted and verified to ensure the safety\n and quality of service for your loved\n ones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D4987),
                      height: 1.70,

                      shadows:  [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LanguageChip(),
                    ],
                  ),
                  SizedBox(height:30 ),

                  OnboardingIndicator(
                    currentIndex: 1,
                    itemCount: 3,
                  ),

                  SizedBox(height: 14 * s),



                  SizedBox(height: 16 * s),

                  NextButton(
                    text: 'Get Started',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    withArrow: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}