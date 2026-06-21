import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/caregiver_reupload_documents_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/reset_password_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/select_role_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_background.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_text_field.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/splash/ui/widgets/next_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import '../../../bottom_nav_bar/ui/widget/admin_bottom.dart';
import '../../manager/auth_cubit.dart';
import '../../manager/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter email and password',
      );
      return;
    }

    context.read<AuthCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  void _navigateAfterLogin(String role) {
    final normalizedRole = role.toLowerCase();
    final Widget homeScreen;

    if (normalizedRole == 'client') {
      homeScreen = const HomeScreen();
    } else if (normalizedRole == 'giver' || normalizedRole == 'caregiver') {
      homeScreen = const CareGiverBottomNavScreen();
    } else if (normalizedRole == 'admin') {
      homeScreen = const AdminButtomNavBar();
    } else {
      homeScreen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => homeScreen),
    );
  }

  void _showCaregiverRejectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: const BoxDecoration(
                  color: Color(0xffEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: const Color(0xff2F93E6),
                  size: 32.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text('documents_need_review'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Your uploaded documents contain incorrect or unclear information. Please review your documents and upload the correct files to continue.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xff64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CaregiverReuploadDocumentsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2F93E6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text('upload_docs_again'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('close'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.authenticated) {
          _navigateAfterLogin(state.userRole);
        }

        if (state.status == AuthStatus.caregiverRejected) {
          _showCaregiverRejectionDialog();
        }

        if (state.status == AuthStatus.error) {
          CustomSnackBar.show(
            context,
            message: 'Invalid email or password',
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: AuthBackground(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: Container(
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),

                ),
                child: Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 120.w,
                              height: 120.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 14.h),
                            Text('welcome_back'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyle.extraBold.copyWith(
                                fontSize: 36.sp,
                                color: const Color(0xFF22304A),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: Offset(0, 2),
                                    blurRadius: 3.r,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.h),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('email'.tr(),
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF3F4D63),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            AuthTextField(
                              controller: emailController,
                              hintText: 'email_placeholder'.tr(),
                              prefixIcon: Icons.mail_outline_rounded,
                            ),

                            SizedBox(height: 20.h),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('password'.tr(),
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF3F4D63),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            AuthTextField(
                              controller: passwordController,
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: isObscure,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF314158),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            state.status == AuthStatus.loading
                                ? CircularProgressIndicator()
                                : NextButton(
                              text: 'Sign In',
                              onTap: _login,
                              withArrow: false,
                            ),

                            SizedBox(height: 8.h),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text('forgot_password'.tr(),
                                  style: AppTextStyle.medium.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30.h),

                            RichText(
                              text: TextSpan(
                                style: AppTextStyle.regular.copyWith(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF667085),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Don't have an account?  ",
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: AppTextStyle.semiBold.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.primaryBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SelectRoleScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30.h),

                            GestureDetector(
                              onTap: () {
                                context.read<AuthCubit>().loginAsGuest();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                );
                              },
                              child: Text('continue_as_guest'.tr(),
                                style: AppTextStyle.semiBold.copyWith(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF2EA63A),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: Offset(0, 4),
                                      blurRadius: 4.r,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 18.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}