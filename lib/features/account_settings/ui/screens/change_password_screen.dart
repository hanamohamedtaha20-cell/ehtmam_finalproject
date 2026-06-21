import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/account_settings_cubit.dart';
import '../../manager/account_settings_state.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void submitPassword() {
    if (!formKey.currentState!.validate()) return;

    context.read<AccountSettingsCubit>().changePassword(
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
  }

  Widget passwordField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1D2939),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          color: Color(0xFF98A2B3),
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          size: 18.r,
          color: Color(0xFF98A2B3),
        ),
        errorStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9.sp,
        ),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget gradientButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : submitPassword,
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: const Color(0xFF3A8BD7).withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              colors: [
                Color(0xFF3A8BD7), // الأزرق
                Color(0xFFBFDBFF), // الفاتح
              ],
              stops: [0.5, 10], // 👈 هنا السحر
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? SizedBox(
                key: ValueKey('loading'),
                width: 18.w,
                height: 18.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                key: ValueKey('text'),
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,           // 👈 زي Figma
                  fontWeight: FontWeight.w600, // SemiBold = 600
                  height: 24.h / 16,        // 👈 line height 24px
                  letterSpacing: 0,       // 👈 زي Figma
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message!)));
        }

        if (state.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F8FC),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4FF),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20.r,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.red, size: 16.r),
                                  label: Text('back_to_login'.tr(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.h),

                              CircleAvatar(
                                radius: 34,
                                backgroundColor: Color(0xFF4EA3F1),
                                child: Icon(Icons.mail_outline_rounded,
                                    color: Colors.white, size: 30.r),
                              ),

                              SizedBox(height: 16.h),

                              Text('change_password'.tr(),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: 6.h),

                              Text(
                                'Enter your current password and\nchoose a new password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF667085),
                                ),
                              ),

                              SizedBox(height: 20.h),

                              passwordField(
                                controller: oldPasswordController,
                                hint: 'Old Password',
                                validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                              ),

                              SizedBox(height: 10.h),

                              passwordField(
                                controller: newPasswordController,
                                hint: 'New Password',
                                validator: (v) {
                                  if (v!.isEmpty) return 'Required';
                                  if (v.length < 6) return 'Min 6 chars';
                                  return null;
                                },
                              ),

                              SizedBox(height: 10.h),

                              passwordField(
                                controller: confirmPasswordController,
                                hint: 'Confirm New Password',
                                validator: (v) {
                                  if (v != newPasswordController.text) {
                                    return 'Not match';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16.h),

                              gradientButton(state.isLoading),

                              SizedBox(height: 16.h),

                             
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}