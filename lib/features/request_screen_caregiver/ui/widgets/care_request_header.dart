import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/screens/home_screen_caregiver.dart';
import 'package:flutter/material.dart';

class RequestHeader extends StatelessWidget {
  const RequestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 18,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HcHomeScreen(),
                  ),
                );

                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "Care Requests",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          /// LANGUAGE BUTTON
          Row(
            children: [
               LanguageSwitcher(),
              ],
            ),
        ],
      ),
    );
  }
}