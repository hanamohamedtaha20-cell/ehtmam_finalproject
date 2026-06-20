import 'package:ehtemam_final_project/core/resources/app_fonts.dart';
import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_state.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/pending_aproval_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/upload_box.dart';
import 'package:ehtemam_final_project/features/splash/ui/widgets/next_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/register_header.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/register_input_field.dart';


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
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  String? selectedGovernment;
  String? selectedCareField;
  String? selectedSpecialization;

  PlatformFile? profileFile;
  PlatformFile? nationalIdFile;
  PlatformFile? certificateFile;
  PlatformFile? mentalHealthFile;

  String? profileUploadError;
  String? nationalIdUploadError;
  String? certificateUploadError;
  String? mentalHealthUploadError;

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
    'Nursing Assistant': [
      'Clinical Support',
      'Medication Assistance',
      'Patient Care',
      'Wound Care',
    ],
    'Shopping Assistant': [
      'Grocery Shopping',
      'Pharmacy Pickup',
      'Online Orders',
      'General Errands',
    ],
  };

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    streetController.dispose();
    buildingController.dispose();
    super.dispose();

  }

  Future<void> _pickFile({required String type, bool allowPdf = false}) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: allowPdf ? FileType.custom : FileType.image,
        allowedExtensions: allowPdf ? ['pdf', 'jpg', 'jpeg', 'png'] : null,
        allowMultiple: false,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.first;
        debugPrint('[Upload] type=$type file=${picked.name} path=${picked.path}');
        setState(() {
          if (type == 'profile') {
            profileFile = picked;
            profileUploadError = null;
          } else if (type == 'nationalId') {
            nationalIdFile = picked;
            nationalIdUploadError = null;
          } else if (type == 'certificate') {
            certificateFile = picked;
            certificateUploadError = null;
          } else if (type == 'mentalHealth') {
            mentalHealthFile = picked;
            mentalHealthUploadError = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, message: 'Upload failed: $e');
      }
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
      mentalHealthUploadError = isCareGiver && mentalHealthFile == null
          ? 'Please upload your Mental Health Document'
          : null;
    });

    final bool filesValid = profileFile != null &&
        nationalIdFile != null &&
        (!isCareGiver ||
            (certificateFile != null && mentalHealthFile != null));

    if (isFormValid && filesValid) {
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
            mentalHealthFile: mentalHealthFile,
            street: streetController.text.trim(),
            building: buildingController.text.trim(),
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
          debugPrint('REGISTER_ROLE: ${widget.role}');

          if (isCareGiver) {
            debugPrint('NAVIGATING_TO: PendingApprovalScreen');
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
          } else {
            debugPrint('NAVIGATING_TO: LoginScreen');
            CustomSnackBar.show(
              context,
              message: 'Account created successfully. Please login.',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
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
              SizedBox(height: 22.h),

              _label('Full Name'),
              SizedBox(height: 6.h),
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

              SizedBox(height: 12.h),

              _label('Email'),
              SizedBox(height: 6.h),
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

              SizedBox(height: 12.h),

              if (isCareGiver) ...[
                _label('Care Field'),
                SizedBox(height: 6.h),
                _dropdownField(
                  value: selectedCareField,
                  hintText: 'Select Care Field...',
                  icon: Icons.medical_services_outlined,
                  items: [
                    'Pet Care',
                    'Elderly Care',
                    'Child Care',
                    'Plant Care',
                    'Nursing Assistant',
                    'Shopping Assistant',
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCareField = value;
                      selectedSpecialization = null;
                    });
                  },
                  validatorText: 'Care field is required',
                ),

                SizedBox(height: 12.h),

                _label('Specialization'),
                SizedBox(height: 6.h),
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

                SizedBox(height: 12.h),
              ],

              _label('Government'),
              SizedBox(height: 6.h),
              _dropdownField(
                value: selectedGovernment,
                hintText: 'Select your Government',
                icon: Icons.location_on_outlined,
                items: [
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



              SizedBox(height: 12.h),
              _label('Street'),
              SizedBox(height: 6.h),
              RegisterInputField(
                controller: streetController,
                hintText: 'Enter your street',
                prefixIcon: Icons.signpost_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Street is required';
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              _label('Building'),
              SizedBox(height: 6.h),
              RegisterInputField(
                controller: buildingController,
                hintText: 'Enter your building number',
                prefixIcon: Icons.apartment_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Building is required';
                  return null;
                },
              ),

              _label('Phone Number'),
              SizedBox(height: 6.h),
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

              SizedBox(height: 12.h),

              _label('Password'),
              SizedBox(height: 6.h),
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
                    size: 18.r,
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

              SizedBox(height: 12.h),

              _label('Confirm Password'),
              SizedBox(height: 6.h),
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
                    size: 18.r,
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

              SizedBox(height: 14.h),

              UploadBox(
                title: 'Upload Profile Picture',
                isRequired: true,
                fileName: profileFile?.name,
                onTap: () async {
                  await _pickFile(type: 'profile');
                },
              ),
              if (profileUploadError != null) _errorText(profileUploadError!),

              SizedBox(height: 12.h),

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
                SizedBox(height: 12.h),
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

                SizedBox(height: 12.h),
                UploadBox(
                  title: 'Mental Health Document',
                  isRequired: true,
                  fileName: mentalHealthFile?.name,
                  acceptedFormats: 'PDF, PNG, JPG, JPEG',
                  onTap: () async {
                    await _pickFile(type: 'mentalHealth', allowPdf: true);
                  },
                ),
                if (mentalHealthUploadError != null)
                  _errorText(mentalHealthUploadError!),
              ],

              SizedBox(height: 18.h),

              state.status == AuthStatus.loading
                  ? CircularProgressIndicator()
                  : NextButton(
                text: 'Sign Up',
                onTap: _submitForm,
              ),

              SizedBox(height: 14.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xFF98A2B3),
                  ),
                  children: [
                    const TextSpan(
                      text: 'Already have an account? ',
                    ),
                    TextSpan(
                      text: 'Sign In',
                      style: AppTextStyle.semiBold.copyWith(
                        fontSize: 12.sp,
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
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF98A2B3),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFF98A2B3),
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFB0BAC8),
          size: 18.r,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFE4E7EC),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFF4A90E2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(color: Colors.black),
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
      padding: EdgeInsets.only(top: 6.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppTextStyle.regular.copyWith(
            fontSize: 11.sp,
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
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF314158),
        ),
      ),
    );
  }
}
