import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

        Text("My Profile",
            style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.textDark)),
        const Spacer(),
        //localization
      ],
    );
  }
}