import 'package:ehtemam_final_project/features/login_required_screen/ui/widgets/pirmary.dart';
import 'package:flutter/material.dart';

import '../../../home_screen/ui/home_screen.dart';
import 'outline_bottom.dart';

class LoginRequiredCard extends StatelessWidget {
  const LoginRequiredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Icon
            Container(
              padding: const EdgeInsets.all(6),
              child: Image.asset("images/lock.png", height: 80),
            ),

            /// 🔹 Title
            const Text(
              "Login Required",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 Description
            const Text(
              "You need to login or create an account to create service requests",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🔹 Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Image.asset("images/🔐.png", height: 50),
                  SizedBox(height: 10),
                  Text(
                    "As a guest, you can browse the app but cannot create requests",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Login Button
            PrimaryButton(
              text: "Login to Continue",
              icon: Icons.login,
              onTap: () {},
            ),

            const SizedBox(height: 10),

            /// 🔹 Create Account
            OutlineButton(
              text: "Create Account",
              icon: Icons.person_add,
              onTap: () {},
            ),

            const SizedBox(height: 10),

            /// 🔹 Back
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text(
                "Back to Home",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
