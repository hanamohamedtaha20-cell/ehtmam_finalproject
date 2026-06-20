import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:ehtemam_final_project/core/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                /// Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SkipButton(),
                  ],
                ),

                SizedBox(height: 30.h),


                /// LOGO
                Image.asset(
                  AppImages.logo2,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 20.h),

                /// 🔥 Welcome to (gradient + shadow + size 48)
                /// Welcome Text
                Text(
                  "Welcome to\nEhtemam",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40.sp,
                    color: Color(0xFF326986),
                    shadows: [
                      Shadow(
                        color: Color(0x70000000),
                        blurRadius: 2.r,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 60.h),

                /// Description
                 Text(
                  "Your Trusted platform for quality\ncare services - pet care, elderly\ncare, and child care all in one\nplace.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.cardBlueStart,

                    shadows: [
                      Shadow(
                        color: Colors.black12.withOpacity(0.2),
                        offset: Offset(0, 6),
                        blurRadius: 2.r//
                      ),
                    ],
                  ),
                ),

                //SizedBox(height: 70.h),
                Spacer(),

                SizedBox(height:20 ),


                /// Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    _dot(false),
                    _dot(false),
                  ],
                ),


                SizedBox(height: 18.h),

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

                SizedBox(height: 20.h),
           ],
            ),
          ),
        ),
      )
      );
    }}


  Widget _dot(bool active) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: active ? 18 : 8,
      height: 8.h,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryBlue
            : AppColors.indicatorInactive.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }