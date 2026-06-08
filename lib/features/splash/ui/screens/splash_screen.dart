import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/splash_cubit.dart';
import '../../manager/splash_state.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../../onboarding/ui/screens/ob1.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> logoAnim;
  late Animation<double> textAnim;
  late Animation<double> dotsAnim;

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 393).clamp(0.85, 1.15);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:  Duration(seconds: 5),
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
      context.read<SplashCubit>().startSplashTimer();
    });
  }

  @override


  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.navigate) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OnboardingScreen(),
            ),
          );
        }
      },
      child: Center(
        child: Scaffold(
          body: SplashBackground(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24 * s,
                  vertical: 18 * s,
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

                    SizedBox(height: 45 * s),

                    FadeTransition(
                      opacity: textAnim,
                      child: ScaleTransition(
                        scale: textAnim,
                        child: Text(
                          'Connecting families with\ntrusted care services',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body16.copyWith(
                            fontFamily: AppFonts.inter,
                            fontSize: 17 * s,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF252E68),
                            height: 1.45,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 26 * s),


                    const Spacer(),

                    SizedBox(height: 30 * s),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}