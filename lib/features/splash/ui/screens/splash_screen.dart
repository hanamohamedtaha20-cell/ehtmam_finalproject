import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/splash_cubit.dart';
import '../../manager/splash_state.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../../onboarding/ui/screens/ob1.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_indicator.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 393).clamp(0.85, 1.15);
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SplashCubit>().startSplashTimer();
    });
  }

  @override
  void dispose() {
    context.read<SplashCubit>().disposeTimer();
    super.dispose();
  }

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

                  const SplashLogo(),

                  SizedBox(height: 42 * s),

                  Text(
                    'Connecting families with\ntrusted care services',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body16.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 16 * s,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF302A68),
                      height: 1.45,
                    ),
                  ),

                  SizedBox(height: 26 * s),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _serviceItem(
                        context: context,
                        icon: Icons.pets_outlined,
                        label: 'Pet Care',
                        bgColor: const Color(0xFFD3E1EF),
                      ),
                      SizedBox(width: 14 * s),
                      _serviceItem(
                        context: context,
                        icon: Icons.elderly_outlined,
                        label: 'Elderly Care',
                        bgColor: const Color(0xFF97CCFD),
                      ),
                      SizedBox(width: 14 * s),
                      _serviceItem(
                        context: context,
                        icon: Icons.child_care_outlined,
                        label: 'Child Care',
                        bgColor: const Color(0xFFE7F8ED),
                      ),
                      SizedBox(width: 14 * s),
                      _serviceItem(
                        context: context,
                        label: 'Plant Care',
                        bgColor: const Color(0xFFE7F8ED),
                        imagePath: 'assets/images/leaf.png',
                      ),
                    ],
                  ),

                  SizedBox(height: 54 * s),

                  Text(
                    'Professional pet care, elderly\ncare, and child care services -\nall in one platform',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body16.copyWith(
                      fontFamily: 'Inter',
                      fontSize: 16 * s,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF302A68),
                      height: 1.45,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SplashIndicator(),
                      SizedBox(width: 6 * s),
                      const SplashIndicator(),
                      SizedBox(width: 6 * s),
                      const SplashIndicator(),
                    ],
                  ),

                  SizedBox(height: 30 * s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceItem({
    required BuildContext context,
    IconData? icon,
    required String label,
    required Color bgColor,
    String? imagePath,
  }) {
    final s = scale(context);

    return Column(
      children: [
        Container(
          width: 56 * s,
          height: 56 * s,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14 * s),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: imagePath != null
                ? Image.asset(
              imagePath,
              width: 42 * s,
              height: 42 * s,
              fit: BoxFit.contain,
            )
                : Icon(
              icon,
              color: const Color(0xFF302A68),
              size: 24 * s,
            ),
          ),
        ),
        SizedBox(height: 6 * s),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12 * s,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF302A68),
            shadows: const [
              Shadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}