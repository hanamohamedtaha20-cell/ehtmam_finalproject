import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/splash_cubit.dart';
import '../../manager/splash_state.dart';
import '../../../../core/resources/app_text_style.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> logoAnim;
  late Animation<double> textAnim;
  late Animation<double> dotsAnim;

  @override
  void initState() {
    super.initState();

    print('🔥 SPLASH OPENED');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    logoAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    textAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.8, curve: Curves.easeOut),
    );

    dotsAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.microtask(() {
      if (!mounted) return;
      print('⏳ SPLASH TIMER STARTED');
      context.read<SplashCubit>().startSplashTimer();
    });
  }

  @override
  void dispose() {
    print('🛑 SPLASH DISPOSED');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 SPLASH BUILD');

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        print('👂 SPLASH STATE navigate = ${state.navigate}');

        if (state.navigate) {
          print('➡️ SPLASH NAVIGATING TO NEXT SCREEN');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => widget.nextScreen,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4DA8F3),
        body: SplashBackground(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 18.h,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  FadeTransition(
                    opacity: logoAnim,
                    child: ScaleTransition(
                      scale: logoAnim,
                      child: const Center(
                        child: SplashLogo(),
                      ),
                    ),
                  ),
                  SizedBox(height: 45.h),
                  FadeTransition(
                    opacity: textAnim,
                    child: ScaleTransition(
                      scale: textAnim,
                      child: Text(
                        'Connecting families with\ntrusted care services',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body16.copyWith(
                          fontFamily: AppFonts.inter,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF252E68),
                          height: 1.45,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 26.h),
                  const Spacer(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}