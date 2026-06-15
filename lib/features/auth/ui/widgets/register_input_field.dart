import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterInputField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const RegisterInputField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFFB0BAC8),
          size: 18.r,
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFB0BAC8),
          fontSize: 13.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFE3E8EF),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFE3E8EF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFF7EC4F0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}