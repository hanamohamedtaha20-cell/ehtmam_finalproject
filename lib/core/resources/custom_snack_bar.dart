import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar {
  static void show(
      BuildContext context, {
        required String message,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF7EC4F0),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
          side: BorderSide(
            color: Colors.white,
            width: 1.5.w,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}