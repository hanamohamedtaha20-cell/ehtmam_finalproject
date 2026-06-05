import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../home_screen/ui/home_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: Icon(Icons.arrow_back)),

        const Text("myProfile",
            style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
        const Spacer(),
        //localization
      ],
    );
  }
}