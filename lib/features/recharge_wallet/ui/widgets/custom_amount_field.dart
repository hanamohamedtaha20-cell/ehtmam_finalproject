import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAmountField extends StatelessWidget {
  final TextEditingController controller;

  const CustomAmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontFamily: "Arimo", fontSize: 14.sp),
      ),
    );
  }
}