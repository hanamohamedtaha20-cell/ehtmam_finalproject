import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/core/widgets/full_screen_image_page.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_careprovider.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaregiverProfileCard extends StatelessWidget {
  final CaregiverModel profile;

  const CaregiverProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.r),
      width: double.infinity,
      padding: EdgeInsets.all(24.r), // 23.99px ≈ 24
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue,AppColors.blue,Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r), // radius 24px
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: profile.profilePicture.isNotEmpty
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImagePage(imageUrl: profile.profilePicture),
                          ),
                        )
                    : null,
                child: Container(
                  margin: EdgeInsets.all(8.r),
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A6F4),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: profile.profilePicture.isNotEmpty
                      ? Image.network(
                          profile.profilePicture,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.person,
                            size: 28.r,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.person, size: 28.r, color: Colors.white),
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: TextStyle(
                            fontFamily: "Arimo",
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: Colors.white)),
                    Text(profile.specialty,
                        style: TextStyle(
                            fontFamily: "Arimo",
                            fontSize: 12.sp,
                            color: Color.fromARGB(158, 255, 255, 255))),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.r, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text(
                          "${profile.rating} (${profile.reviews} reviews)",
                          style: TextStyle(
                              fontFamily: "Arimo",
                              fontSize: 12.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CareProviderAccountSettingsScreen()),
            ),
            child: Container(
              margin: EdgeInsets.all(10.r),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text("Edit Profile",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}