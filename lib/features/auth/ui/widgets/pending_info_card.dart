import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/splash/ui/widgets/next_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
class PendingInfoCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const PendingInfoCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 22, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3EBF3),
            Color(0xFFD9E6F2),
            Color(0xFFA8D4FA),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 92.w,
            height: 92.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1F5EA8),
                  Color(0xFF5DBAF7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5DBAF7).withOpacity(0.35),
                  blurRadius: 16.r,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 48.r,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Pending\nApproval',
            textAlign: TextAlign.center,
            style: AppTextStyle.extraBold.copyWith(
              fontSize: 24.sp,
              height: 1.15.h,
              color: const Color(0xFF1263B8),
            ),
          ),
          SizedBox(height: 14.h),
          Text('account_under_review'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.medium.copyWith(
              fontSize: 18.sp,
              color: const Color(0xFF5B6D83),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Please wait while our admin team\nreviews your documents. You will\nbe notified once approved.',
            textAlign: TextAlign.center,
            style: AppTextStyle.regular.copyWith(
              fontSize: 15.sp,
              height: 1.6.h,
              color: const Color(0xFF6A7C93),
            ),
          ),
          SizedBox(height: 26.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('registration_complete'.tr(),
                  style: AppTextStyle.bold.copyWith(
                    fontSize: 16.sp,
                    color: const Color(0xFF46566B),
                  ),
                ),
                SizedBox(height: 14.h),
                _infoRow('Full Name:', fullName),
                SizedBox(height: 10.h),
                _infoRow('Email:', email),
                SizedBox(height: 10.h),
                _infoRow('Phone Number:', phoneNumber),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Text('approval_status'.tr(),
                      style: AppTextStyle.medium.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xFF667085),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE7BF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text('pending'.tr(),
                        style: AppTextStyle.semiBold.copyWith(
                          fontSize: 13.sp,
                          color: const Color(0xFFDD8A00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 26.h),
          NextButton(
            text: 'Pending...',
            onTap: () {},
          ),

          SizedBox(height: 18.h),

          RichText(
            text: TextSpan(
              style: AppTextStyle.regular.copyWith(
                fontSize: 15.sp,
                color: Colors.red,
              ),
              children: [
                TextSpan(
                  text: 'Back to Login',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105.w,
          child: Text(
            label,
            style: AppTextStyle.medium.copyWith(
              fontSize: 14.sp,
              color: const Color(0xFF667085),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.medium.copyWith(
              fontSize: 14.sp,
              color: const Color(0xFF344054),
            ),
          ),
        ),
      ],
    );
  }
}