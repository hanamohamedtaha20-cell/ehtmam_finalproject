import 'package:ehtemam_final_project/core/resources/language_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/account_settings_cubit.dart';
import '../../manager/account_settings_state.dart';

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
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1D2939),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          color: Color(0xFF98A2B3),
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          size: 18,
          color: Color(0xFF98A2B3),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 9,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget gradientButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : submitPassword,
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: const Color(0xFF3A8BD7).withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
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
                  ? const SizedBox(
                key: ValueKey('loading'),
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                key: ValueKey('text'),
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,           // 👈 زي Figma
                  fontWeight: FontWeight.w600, // SemiBold = 600
                  height: 24 / 16,        // 👈 line height 24px
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4FF),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
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
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.red, size: 16),
                                  label: const Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const CircleAvatar(
                                radius: 34,
                                backgroundColor: Color(0xFF4EA3F1),
                                child: Icon(Icons.mail_outline_rounded,
                                    color: Colors.white, size: 30),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Enter your current password and\nchoose a new password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF667085),
                                ),
                              ),

                              const SizedBox(height: 20),

                              passwordField(
                                controller: oldPasswordController,
                                hint: 'Old Password',
                                validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                              ),

                              const SizedBox(height: 10),

                              passwordField(
                                controller: newPasswordController,
                                hint: 'New Password',
                                validator: (v) {
                                  if (v!.isEmpty) return 'Required';
                                  if (v.length < 6) return 'Min 6 chars';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

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

                              const SizedBox(height: 16),

                              gradientButton(state.isLoading),

                              const SizedBox(height: 16),

                              Container(
                                height: 14,
                                alignment: Alignment.center,
                                color: Colors.white.withOpacity(0.3),
                                child: const Text(
                                  'User Access',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    color: Color(0xFF98A2B3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Positioned(
                    top: 6,
                    right: 0,
                    child: LanguageChip(),
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