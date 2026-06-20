import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_background.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/register_password_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Column(
            children: [
             
              SizedBox(height: 55.h),
              const ResetPasswordCard(),
            ],
          ),
        ),
      ),
    );
  }
}