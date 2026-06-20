import 'package:ehtemam_final_project/features/auth/manager/reset_password_cubit.dart';
import 'package:ehtemam_final_project/features/auth/manager/reset_password_state.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_text_field.dart';
import 'package:ehtemam_final_project/features/splash/ui/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/app_text_style.dart';

class SetNewPasswordScreen extends StatelessWidget {
  final String token;

  const SetNewPasswordScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: _SetNewPasswordBody(token: token),
    );
  }
}

class _SetNewPasswordBody extends StatefulWidget {
  final String token;

  const _SetNewPasswordBody({required this.token});

  @override
  State<_SetNewPasswordBody> createState() => _SetNewPasswordBodyState();
}

class _SetNewPasswordBodyState extends State<_SetNewPasswordBody> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both fields.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    context.read<ResetPasswordCubit>().resetPassword(
          token: widget.token,
          password: password,
          confirmPassword: confirm,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF2FA),
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            });
          }
          if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFDCE7F0).withValues(alpha: 0.95),
                      const Color(0xFFB8D9F5).withValues(alpha: 0.95),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 30.r,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Icon ────────────────────────────────────────────────
                    Container(
                      width: 74.w,
                      height: 74.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF358BFF), Color(0xFF0E9AD8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF358BFF).withValues(alpha: 0.30),
                            blurRadius: 18.r,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(Icons.lock_reset_rounded,
                          color: Colors.white, size: 38.r),
                    ),

                    SizedBox(height: 24.h),

                    Text(
                      'Set New Password',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.extraBold.copyWith(
                        fontSize: 24.sp,
                        color: const Color(0xFF22304A),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      'Choose a strong password\nfor your account',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 16.sp,
                        height: 1.5.h,
                        color: const Color(0xFF5E6E86),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── New password ─────────────────────────────────────────
                    AuthTextField(
                      controller: _passwordController,
                      hintText: 'New password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8A94A6),
                          size: 20.r,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Confirm password ─────────────────────────────────────
                    AuthTextField(
                      controller: _confirmController,
                      hintText: 'Confirm new password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8A94A6),
                          size: 20.r,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Button / loading ─────────────────────────────────────
                    BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                      builder: (context, state) {
                        if (state is ResetPasswordLoading) {
                          return SizedBox(
                            height: 56.h,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return NextButton(
                          text: 'Reset Password',
                          onTap: _submit,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
