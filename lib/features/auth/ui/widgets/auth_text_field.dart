import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF314158),
          ),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF8A94A6),
            fontSize: 16.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}