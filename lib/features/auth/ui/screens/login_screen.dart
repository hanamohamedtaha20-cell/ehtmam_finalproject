import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/core/resources/language_chip.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/reset_password_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/select_role_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_background.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_text_field.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
import 'package:ehtemam_final_project/features/profile2/ui/screens/profile_screen.dart';
import 'package:ehtemam_final_project/features/rating/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/splash/ui/widgets/next_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/resources/app_colors.dart';
import '../../manager/auth_cubit.dart';
import '../../manager/auth_state.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/screens/home_screen_caregiver.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.authenticated) {
          final prefs = await SharedPreferences.getInstance();
          final role = prefs.getString('user_role') ?? '';

          if (role == 'caregiver') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HcHomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                ),
                child: Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Welcome back',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.extraBold.copyWith(
                                fontSize: 36,
                                color: const Color(0xFF22304A),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(0, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF3F4D63),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            AuthTextField(
                              controller: emailController,
                              hintText: 'your@email.com',
                              prefixIcon: Icons.mail_outline_rounded,
                            ),

                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF3F4D63),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
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

                            const SizedBox(height: 20),

                            state.status == AuthStatus.loading
                                ? const CircularProgressIndicator()
                                : NextButton(
                              text: 'Sign In',
                              onTap: _login,
                              withArrow: false,
                            ),

                            const SizedBox(height: 8),

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
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyle.medium.copyWith(
                                    fontSize: 13,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            RichText(
                              text: TextSpan(
                                style: AppTextStyle.regular.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF667085),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Don't have an account?  ",
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: AppTextStyle.semiBold.copyWith(
                                      fontSize: 16,
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

                            const SizedBox(height: 30),

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomeScreen()),
                                );
                              },
                              child: Text(
                                'Continue as a Guest!',
                                style: AppTextStyle.semiBold.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xFF2EA63A),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
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