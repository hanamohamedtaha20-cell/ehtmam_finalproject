import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/material.dart';

class CaregiverProfileCard extends StatelessWidget {
  final CaregiverModel profile;

  const CaregiverProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      width: double.infinity,
      padding: const EdgeInsets.all(24), // 23.99px ≈ 24
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blue,AppColors.blue,Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24), // radius 24px
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              margin: EdgeInsets.all(8),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF00A6F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, size: 28, color: Colors.white),
            ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: const TextStyle(
                            fontFamily: "Arimo",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white)),
                    Text(profile.specialty,
                        style: const TextStyle(
                            fontFamily: "Arimo",
                            fontSize: 12,
                            color: Color.fromARGB(158, 255, 255, 255))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "${profile.rating} (${profile.reviews} reviews)",
                          style: const TextStyle(
                              fontFamily: "Arimo",
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text("Edit Profile",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}