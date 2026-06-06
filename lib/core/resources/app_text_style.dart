
import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  static const TextStyle regular = TextStyle(
    fontFamily: AppFonts.inter,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: AppFonts.inter,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle semiBold = TextStyle(
    fontFamily: AppFonts.inter,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bold = TextStyle(
    fontFamily: AppFonts.inter,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle extraBold = TextStyle(
    fontFamily: AppFonts.inter,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle title20 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
  static const TextStyle body16 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2F5E96),
  );

  static const TextStyle button16 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle skip16 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF7C889C),
  );

  static const TextStyle language14 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF5C6B82),
  );
  static const TextStyle welcome = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle brand = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle onboardingTitle40 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: Color(0xFF1D293D),
    height: 1.15,
  );

  static const TextStyle onboardingBody18 = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Color(0xFF314158),
    height: 1.6,
  );
}