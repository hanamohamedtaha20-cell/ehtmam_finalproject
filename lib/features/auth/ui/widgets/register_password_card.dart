import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../../splash/ui/widgets/next_button.dart';
import 'auth_text_field.dart';

class ResetPasswordCard extends StatelessWidget {
  const ResetPasswordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFDCE7F0).withOpacity(0.95),
            const Color(0xFFB8D9F5).withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 30.r,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18.r,
                    color: Color(0xFF465A76),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Back to Login',
                    style: AppTextStyle.medium.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xFF465A76),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Container(
            width: 74.w,
            height: 74.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF358BFF),
                  Color(0xFF0E9AD8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF358BFF).withOpacity(0.30),
                  blurRadius: 18.r,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.mail_outline_rounded,
              color: Colors.white,
              size: 38.r,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Reset Password',
            textAlign: TextAlign.center,
            style: AppTextStyle.extraBold.copyWith(
              fontSize: 24.sp,
              color: const Color(0xFF22304A),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Enter your email address and we'll\nsend you a link to reset your\npassword",
            textAlign: TextAlign.center,
            style: AppTextStyle.regular.copyWith(
              fontSize: 16.sp,
              height: 1.5.h,
              color: const Color(0xFF5E6E86),
            ),
          ),
          SizedBox(height: 20.h),
           AuthTextField(
            hintText: 'Email',
            prefixIcon: Icons.mail_outline_rounded,
          ),
          SizedBox(height: 20.h),
          NextButton(
            text: 'Send Reset Link',
            onTap:(){
            },

          ),
        ],
      ),
    );
  }
}