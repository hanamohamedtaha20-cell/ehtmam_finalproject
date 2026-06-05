import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/language_chip.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/login_screen.dart';
import 'package:ehtmam_finalproject/features/auth/ui/widgets/pending_info_card.dart';

class PendingApprovalScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const PendingApprovalScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    child: PendingInfoCard(
                      fullName: fullName,
                      email: email,
                      phoneNumber: phoneNumber,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF98A2B3),
                    ),
                    children: [
                      const TextSpan(
                        text:
                        "We'll notify you via email once your account is reviewed. ",
                      ),
                      TextSpan(
                        text: '',
                        recognizer: TapGestureRecognizer(),
                      ),
                    ],
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