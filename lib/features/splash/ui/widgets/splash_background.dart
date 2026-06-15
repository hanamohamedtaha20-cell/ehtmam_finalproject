import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF4DA8F3),
            Color(0xFFDDEBF7),
            Color(0xFFFFFFFF),
            Color(0xFFEAF6FB),
            Color(0xFF93C9F6),
          ],

          stops: [
            0.0,
            0.22,
            0.50,
            0.72,
            1.0,
          ],
        ),
      ),

      child: child,
    );
  }
}