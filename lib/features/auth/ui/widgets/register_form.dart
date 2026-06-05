import 'package:ehtmam_finalproject/core/resources/app_fonts.dart';
import 'package:ehtmam_finalproject/features/auth/manager/auth_cubit.dart';
import 'package:ehtmam_finalproject/features/auth/manager/auth_state.dart';
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
import '../../../../core/resources/custom_snackbar.dart';
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

  String? selectedGovernment;
  String? selectedCareField;
  String? selectedSpecialization;

  PlatformFile? profileFile;
  PlatformFile? nationalIdFile;
  PlatformFile? certificateFile;

  String? profileUploadError;
  String? nationalIdUploadError;
  String? certificateUploadError;

  bool get isCareGiver => widget.role.toLowerCase().contains('care');

  final Map<String, List<String>> specializationOptions = {
    'Pet Care': [
      'Pet Sitting',
      'Pet Walking',
      'Pet Grooming',
      'Veterinary Support',
    ],
    'Elderly Care': [
      'Home Care',
      'Medical Support',
      'Companionship',
      'Mobility Assistance',
    ],
    'Child Care': [
      'Babysitting',
      'Tutoring',
      'Special Needs Care',
      'Nursery Care',
    ],
    'Plant Care': [
      'Watering',
      'Gardening',
      'Indoor Plants',
      'Landscape Care',
    ],
  };

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile({required String type}) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (type == 'profile') {
            profileFile = result.files.first;
            profileUploadError = null;
          } else if (type == 'nationalId') {
            nationalIdFile = result.files.first;
            nationalIdUploadError = null;
          } else if (type == 'certificate') {
            certificateFile = result.files.first;
            certificateUploadError = null;
          }
        });
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: 'Upload failed: $e',
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

      certificateUploadError = isCareGiver && certificateFile == null
          ? 'Please upload your certificate'
          : null;
    });

    if (isFormValid &&
        profileFile != null &&
        nationalIdFile != null &&
        (!isCareGiver || certificateFile != null)) {
      await context.read<AuthCubit>().register(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: widget.role,
        government: selectedGovernment ?? '',
        careField: selectedCareField ?? '',
        specialization: selectedSpecialization ?? '',
        certificateFileName: certificateFile?.name ?? '',
        profileFile: profileFile,
        nationalIdFile: nationalIdFile,
        certificateFile: certificateFile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currentSpecializations = selectedCareField == null
        ? []
        : specializationOptions[selectedCareField] ?? [];

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.registered) {
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

        if (state.status == AuthStatus.error) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage ?? 'Registration failed',
          );
        }
      },
      builder: (context, state) {
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

              if (isCareGiver) ...[
                _label('Care Field'),
                const SizedBox(height: 6),
                _dropdownField(
                  value: selectedCareField,
                  hintText: 'Select Care Field...',
                  icon: Icons.medical_services_outlined,
                  items: const [
                    'Pet Care',
                    'Elderly Care',
                    'Child Care',
                    'Plant Care',
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCareField = value;
                      selectedSpecialization = null;
                    });
                  },
                  validatorText: 'Care field is required',
                ),

                const SizedBox(height: 12),

                _label('Specialization'),
                const SizedBox(height: 6),
                _dropdownField(
                  value: selectedSpecialization,
                  hintText: 'Select Specialization...',
                  icon: Icons.workspace_premium_outlined,
                  items: currentSpecializations,
                  onChanged: (value) {
                    setState(() {
                      selectedSpecialization = value;
                    });
                  },
                  validatorText: 'Specialization is required',
                ),

                const SizedBox(height: 12),
              ],

              _label('Government'),
              const SizedBox(height: 6),
              _dropdownField(
                value: selectedGovernment,
                hintText: 'Select your Government',
                icon: Icons.location_on_outlined,
                items: const [
                  'Giza',
                  'Cairo',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGovernment = value;
                  });
                },
                validatorText: 'Government is required',
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
                  await _pickFile(type: 'profile');
                },
              ),
              if (profileUploadError != null) _errorText(profileUploadError!),

              const SizedBox(height: 12),

              UploadBox(
                title: 'Upload National ID',
                isRequired: true,
                fileName: nationalIdFile?.name,
                onTap: () async {
                  await _pickFile(type: 'nationalId');
                },
              ),
              if (nationalIdUploadError != null)
                _errorText(nationalIdUploadError!),

              if (isCareGiver) ...[
                const SizedBox(height: 12),
                UploadBox(
                  title: 'Upload Certificate',
                  isRequired: true,
                  fileName: certificateFile?.name,
                  onTap: () async {
                    await _pickFile(type: 'certificate');
                  },
                ),
                if (certificateUploadError != null)
                  _errorText(certificateUploadError!),
              ],

              const SizedBox(height: 18),

              state.status == AuthStatus.loading
                  ? const CircularProgressIndicator()
                  : NextButton(
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
                    const TextSpan(
                      text: 'Already have an account? ',
                    ),
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
      },
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hintText,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required String validatorText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF98A2B3),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF98A2B3),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFB0BAC8),
          size: 18,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF4A90E2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: items.isEmpty ? null : onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }

  Widget _errorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppTextStyle.regular.copyWith(
            fontSize: 11,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyle.medium.copyWith(
          fontFamily: AppFonts.inter,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF314158),
        ),
      ),
    );
  }
}