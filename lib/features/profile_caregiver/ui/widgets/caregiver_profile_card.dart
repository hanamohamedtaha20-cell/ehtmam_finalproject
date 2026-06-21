import 'package:ehtemam_final_project/core/resources/app_colors.dart';
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
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.blue, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 2),
              blurRadius: 4.r),
          BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 6.r),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ─────────────────────────────────────────────────────
          _ProfileAvatar(url: profile.profilePicture),
          SizedBox(width: 16.w),
          // ── Info ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  profile.specialty,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12.sp,
                    color: Color.fromARGB(200, 255, 255, 255),
                  ),
                ),
                if (profile.location.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 13.r, color: Color.fromARGB(200, 255, 255, 255)),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Text(
                          profile.location,
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 11.sp,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 6.h),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String url;
  const _ProfileAvatar({required this.url});

  @override
  Widget build(BuildContext context) {
    final hasImage = url.isNotEmpty;
    return Container(
      width: 68.w,
      height: 68.h,
      decoration: BoxDecoration(
        color: const Color(0xFF00A6F4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.4), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context2, err, stack) => _defaultIcon(),
            )
          : _defaultIcon(),
    );
  }

  Widget _defaultIcon() => Center(
        child: Icon(Icons.person, size: 32, color: Colors.white),
      );
}
