import 'package:ehtmam_finalproject/features/splash/ui/widgets/next_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/app_text_style.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/login_screen.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/register_header.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/register_input_field.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/upload_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../account_settings/manager/account_settings_cubit.dart';
import '../screens/pending_approval_screen.dart';

class RegisterForm extends StatefulWidget {
  final String role;

  const RegisterForm({
    super.key,
    required this.role,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  PlatformFile? profileFile;
  PlatformFile? nationalIdFile;

  String? profileUploadError;
  String? nationalIdUploadError;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile({required bool isProfile}) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (isProfile) {
            profileFile = result.files.first;
            profileUploadError = null;
          } else {
            nationalIdFile = result.files.first;
            nationalIdUploadError = null;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    final bool isFormValid = _formKey.currentState!.validate();

    setState(() {
      profileUploadError =
      profileFile != null ? null : 'Please upload your profile picture';
      nationalIdUploadError =
      nationalIdFile != null ? null : 'Please upload your national ID';
    });

    if (isFormValid && profileFile != null && nationalIdFile != null) {
      await context.read<AccountSettingsCubit>().saveRegisterData(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: widget.role,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PendingApprovalScreen(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RegisterHeader(role: widget.role),
          const SizedBox(height: 22),

          _label('Full Name'),
          const SizedBox(height: 6),
          RegisterInputField(
            controller: fullNameController,
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              if (value.trim().length < 3) {
                return 'Full name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          _label('Email'),
          const SizedBox(height: 6),
          RegisterInputField(
            controller: emailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              final email = value.trim();
              if (!email.contains('@') || !email.contains('.')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          _label('Phone Number'),
          const SizedBox(height: 6),
          RegisterInputField(
            controller: phoneController,
            hintText: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }

              final phone = value.trim();

              if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                return 'Phone number must contain digits only';
              }

              if (phone.length != 11) {
                return 'Phone number must be 11 digits';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          _label('Password'),
          const SizedBox(height: 6),
          RegisterInputField(
            controller: passwordController,
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: isPasswordHidden,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordHidden = !isPasswordHidden;
                });
              },
              icon: Icon(
                isPasswordHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFB0BAC8),
                size: 18,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          _label('Confirm Password'),
          const SizedBox(height: 6),
          RegisterInputField(
            controller: confirmPasswordController,
            hintText: 'Confirm your password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: isConfirmPasswordHidden,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isConfirmPasswordHidden = !isConfirmPasswordHidden;
                });
              },
              icon: Icon(
                isConfirmPasswordHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFB0BAC8),
                size: 18,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          UploadBox(
            title: 'Upload Profile Picture',
            isRequired: true,
            fileName: profileFile?.name,
            onTap: () async {
              await _pickFile(isProfile: true);
            },
          ),
          if (profileUploadError != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                profileUploadError!,
                style: AppTextStyle.regular.copyWith(
                  fontSize: 11,
                  color: Colors.red,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          UploadBox(
            title: 'Upload National ID',
            isRequired: true,
            fileName: nationalIdFile?.name,
            onTap: () async {
              await _pickFile(isProfile: false);
            },
          ),
          if (nationalIdUploadError != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nationalIdUploadError!,
                style: AppTextStyle.regular.copyWith(
                  fontSize: 11,
                  color: Colors.red,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),

          NextButton(
            text: 'Sign Up',
            onTap: _submitForm,
          ),
          const SizedBox(height: 14),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.regular.copyWith(
                fontSize: 12,
                color: const Color(0xFF98A2B3),
              ),
              children: [
                const TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Sign In',
                  style: AppTextStyle.semiBold.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF1AA34A),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyle.medium.copyWith(
          fontSize: 11,
          color: const Color(0xFF7D8896),
        ),
      ),
    );
  }
}