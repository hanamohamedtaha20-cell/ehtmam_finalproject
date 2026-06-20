import 'package:ehtemam_final_project/features/auth/ui/widgets/pending_info_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingApprovalScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const PendingApprovalScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFDFD),
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.r,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
              
                Expanded(
                  child: SingleChildScrollView(
                    child: PendingInfoCard(
                      fullName: fullName,
                      email: email,
                      phoneNumber: phoneNumber,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFF98A2B3),
                    ),
                    children: [
                      const TextSpan(
                        text:
                        "We'll notify you via email once your account is reviewed. ",
                      ),
                      TextSpan(
                        text: '',
                        recognizer: TapGestureRecognizer(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}