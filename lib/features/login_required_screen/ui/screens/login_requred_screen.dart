import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/login_required_card.dart';

class LoginRequiredScreen extends StatelessWidget {
  const LoginRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🔹 Guest text
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16)),

          const SizedBox(height: 20),

          /// 🔹 Card
          Expanded(child: Center(child: LoginRequiredCard())),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Join CareConnect to access all features".tr(),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
