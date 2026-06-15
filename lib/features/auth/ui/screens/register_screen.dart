import 'package:ehtemam_final_project/core/resources/language_chip.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  final String role;

  const RegisterScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                Align(
                  alignment: Alignment.topRight,
                  child: LanguageChip(),
                ),
                SizedBox(height: 18.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: RegisterForm(role: role),
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