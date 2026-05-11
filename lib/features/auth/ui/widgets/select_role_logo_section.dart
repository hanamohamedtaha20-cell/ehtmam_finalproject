import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/app_text_style.dart';

class SelectRoleLogoSection extends StatelessWidget {
  const SelectRoleLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        Text(
          'Select Your Role',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'InriaSerif',
            fontWeight: FontWeight.w700,
            fontSize: 40,
            color: Color(0xff45556C),

            shadows: [
              Shadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Trusted Care Services Platform',
          textAlign: TextAlign.center,
          style: AppTextStyle.regular.copyWith(
            fontSize: 14,
            color:  Color(0xFF3A8BD7),
            fontWeight: FontWeight.w400,
            shadows: [
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