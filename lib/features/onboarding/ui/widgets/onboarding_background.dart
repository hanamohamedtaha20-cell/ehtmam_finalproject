import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({
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

            // darker top left
            Color(0xFF2F7FCD),

            // soft blue
            Color(0xFFAED5F4),

            // bright white center
            Color(0xFFFFFFFF),

            // soft cyan
            Color(0xFFE7F7FD),

            // darker bottom right
            Color(0xFF2F7FCD),
          ],

          stops: [
            0.0,
            0.20,
            0.50,
            0.76,
            1.0,
          ],
        ),
      ),

      child: child,
    );
  }
}