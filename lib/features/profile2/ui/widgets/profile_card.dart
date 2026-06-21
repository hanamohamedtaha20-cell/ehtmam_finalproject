import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/core/widgets/full_screen_image_page.dart';
import 'package:ehtemam_final_project/features/profile2/data/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3A8BD7), Color(0xff97CCFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow:  [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (user.profilePicture?.isNotEmpty ?? false)
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImagePage(imageUrl: user.profilePicture!),
                          ),
                        )
                    : null,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  backgroundImage: (user.profilePicture?.isNotEmpty ?? false)
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  onBackgroundImageError: (user.profilePicture?.isNotEmpty ?? false)
                      ? (_, _) {}
                      : null,
                  child: (user.profilePicture?.isNotEmpty ?? false)
                      ? null
                      : Icon(Icons.person_outline, size: 36.r, color: Colors.white),
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: TextStyle(
                          fontFamily: "Arimo",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.white)),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 12.r, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Text(user.email,
                          style: TextStyle(
                              fontFamily: "Arimo", fontSize: 12.sp, color: Colors.white70)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, size: 12.r, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Text(
                          user.phone.isNotEmpty ? user.phone : 'No phone added',
                          style: TextStyle(
                              fontFamily: "Arimo", fontSize: 12.sp, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}