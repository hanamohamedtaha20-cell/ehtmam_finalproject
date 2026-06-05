import 'package:ehtmam_finalproject/features/splash/ui/widgets/next_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/app_text_style.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/login_screen.dart';
class PendingInfoCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const PendingInfoCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3EBF3),
            Color(0xFFD9E6F2),
            Color(0xFFA8D4FA),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1F5EA8),
                  Color(0xFF5DBAF7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5DBAF7).withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Pending\nApproval',
            textAlign: TextAlign.center,
            style: AppTextStyle.extraBold.copyWith(
              fontSize: 24,
              height: 1.15,
              color: const Color(0xFF1263B8),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Your account is under review',
            textAlign: TextAlign.center,
            style: AppTextStyle.medium.copyWith(
              fontSize: 18,
              color: const Color(0xFF5B6D83),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please wait while our admin team\nreviews your documents. You will\nbe notified once approved.',
            textAlign: TextAlign.center,
            style: AppTextStyle.regular.copyWith(
              fontSize: 15,
              height: 1.6,
              color: const Color(0xFF6A7C93),
            ),
          ),
          const SizedBox(height: 26),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registration Complete!',
                  style: AppTextStyle.bold.copyWith(
                    fontSize: 16,
                    color: const Color(0xFF46566B),
                  ),
                ),
                const SizedBox(height: 14),
                _infoRow('Full Name:', fullName),
                const SizedBox(height: 10),
                _infoRow('Email:', email),
                const SizedBox(height: 10),
                _infoRow('Phone Number:', phoneNumber),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Approval Status:',
                      style: AppTextStyle.medium.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE7BF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pending',
                        style: AppTextStyle.semiBold.copyWith(
                          fontSize: 13,
                          color: const Color(0xFFDD8A00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),
          NextButton(
            text: 'Pending...',
            onTap: () {},
          ),

          const SizedBox(height: 18),

          RichText(
            text: TextSpan(
              style: AppTextStyle.regular.copyWith(
                fontSize: 15,
                color: Colors.red,
              ),
              children: [
                TextSpan(
                  text: 'Back to Login',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                            (route) => false,
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

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: AppTextStyle.medium.copyWith(
              fontSize: 14,
              color: const Color(0xFF667085),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.medium.copyWith(
              fontSize: 14,
              color: const Color(0xFF344054),
            ),
          ),
        ),
      ],
    );
  }
}