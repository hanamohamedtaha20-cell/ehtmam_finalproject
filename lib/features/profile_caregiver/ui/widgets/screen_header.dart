import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/screens/home_screen_caregiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';


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
                  builder: (context) => CareGiverBottomNavScreen(),
                ),
              );
            },
            child: Icon(Icons.arrow_back)),
SizedBox(width: 12.w),
        Text('profile'.tr(),
            style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.black)),
        const Spacer(),
        //localization
      ],
    );
  }
}