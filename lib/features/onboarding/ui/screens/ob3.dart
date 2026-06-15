import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_fonts.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/language_chip.dart';
import '../../../../core/resources/skip_button.dart';
import '../../../splash/ui/widgets/next_button.dart';
import '../widgets/onboarding_indicator.dart';
import 'ob4.dart';
import '../../../onboarding/ui/widgets/onboarding_background.dart';


class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});
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
                horizontal: 20.w,
                vertical: 12.h,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SkipButton(),
                    ],
                  ),

                  SizedBox(height:60 ),

                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF97CCFD),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3A8BD7),
                          offset: Offset(0, 25),
                          blurRadius: 50.r,
                          spreadRadius: -12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        AppImages.verified,
                        width: 60.w ,
                        height: 60.h ,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  Text(
                    'Verified Providers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D293D),
                      shadows:  [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 4.r,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    'All our care providers are thoroughly\nvetted and verified to ensure the safety\n and quality of service for your loved\n ones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D4987),
                      height: 1.70.h,

                      shadows:  [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 4.r,
                        ),
                      ],
                    ),
                  ),

                  Spacer(),


                  OnboardingIndicator(
                    currentIndex: 1,
                    itemCount: 3,
                  ),

                  SizedBox(height: 14.h),





                  NextButton(
                    text: 'Next',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen4(),
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