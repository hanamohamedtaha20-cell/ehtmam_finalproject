import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/language_chip.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final String role;

  const RegisterScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFDFD),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
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
                    child: RegisterForm(role: role),
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