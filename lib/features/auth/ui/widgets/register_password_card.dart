import 'package:ehtemam_final_project/features/auth/manager/forgot_password_cubit.dart';
import 'package:ehtemam_final_project/features/auth/manager/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../../splash/ui/widgets/next_button.dart';
import 'auth_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordCard extends StatelessWidget {
  const ResetPasswordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ResetPasswordCardBody(),
    );
  }
}

class _ResetPasswordCardBody extends StatefulWidget {
  const _ResetPasswordCardBody();

  @override
  State<_ResetPasswordCardBody> createState() => _ResetPasswordCardBodyState();
}

class _ResetPasswordCardBodyState extends State<_ResetPasswordCardBody> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim());
  }

  void _submit() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('enter_email_address'.tr()),
          backgroundColor: Color(0xFF7EC4F0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('enter_valid_email'.tr()),
          backgroundColor: Color(0xFF7EC4F0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    context.read<ForgotPasswordCubit>().sendResetLink(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF7EC4F0),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          );
          // Navigate back to login after a short delay so user can read the SnackBar.
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) Navigator.pop(context);
          });
        }

        if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF7EC4F0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          );
        }
      },
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
            // ── Back to Login ──────────────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 18.r, color: const Color(0xFF465A76)),
                    SizedBox(width: 8.w),
                    Text('back_to_login'.tr(),
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

            // ── Icon ──────────────────────────────────────────────────────
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
              child: Icon(Icons.mail_outline_rounded, color: Colors.white, size: 38.r),
            ),

            SizedBox(height: 24.h),

            Text('reset_password'.tr(),
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

            // ── Email field ───────────────────────────────────────────────
            AuthTextField(
              controller: _emailController,
              hintText: 'email_placeholder'.tr(),
              prefixIcon: Icons.mail_outline_rounded,
            ),

            SizedBox(height: 20.h),

            // ── Submit button / loading indicator ─────────────────────────
            BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              builder: (context, state) {
                if (state is ForgotPasswordLoading) {
                  return SizedBox(
                    height: 56.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return NextButton(
                  text: 'Send Reset Link',
                  onTap: _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
