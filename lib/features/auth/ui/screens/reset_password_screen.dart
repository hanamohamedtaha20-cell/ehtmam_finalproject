import 'package:ehtemam_final_project/features/auth/ui/widgets/auth_background.dart';
import 'package:ehtemam_final_project/features/auth/ui/widgets/register_password_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/language_chip.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: LanguageChip(),
              ),
              const SizedBox(height: 55),
              const ResetPasswordCard(),
            ],
          ),
        ),
      ),
    );
  }
}