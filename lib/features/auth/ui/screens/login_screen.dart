import 'package:ehtmam_finalproject/features/auth/ui/screens/select_role_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/reset_password_screen.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/auth_background.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/auth_text_field.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_text_style.dart';
import '../../../../core/resources/language_chip.dart';
import '../../../main_layout/ui/screens/main_layout_screen.dart';
import '../../../splash/ui/widgets/next_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: LanguageChip(),
                ),
                const SizedBox(height: 18),
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
                            color:  Color(0xFF22304A),
                            shadows: [
                          Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 2),
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
                        const AuthTextField(
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
                        NextButton(
                          text: 'Sign In',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainLayoutScreen(),
                              ),
                            );
                          },
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
                                fontSize:13,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Continue as a Guest!',
                          style: AppTextStyle.semiBold.copyWith(
                            fontSize: 16,
                            color: const Color(0xFF2EA63A),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                                        builder: (context) =>  SelectRoleScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              size: 18,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Admin Login',
                              style: AppTextStyle.medium.copyWith(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
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
  }
}