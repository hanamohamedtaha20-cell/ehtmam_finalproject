import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_careprovider.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/notifications/ui/screens/notification_screen.dart';
import 'package:ehtemam_final_project/features/payment_cg/ui/screens/cg_payment_screen.dart';
import 'package:ehtemam_final_project/features/rating_overview/ui/screens/provider_reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuOptionsCard extends StatelessWidget {
  const MenuOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      _MenuOption(
        icon: Icons.settings_outlined,
        label: "Account Settings",
        iconColor: AppColors.blue,
        bgColor: const Color.fromARGB(255, 240, 249, 255),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CareProviderAccountSettingsScreen()),
        ),
      ),
      // _MenuOption(
      //   icon: Icons.attach_money,
      //   label: "Payments Received",
      //   iconColor: AppColors.blue,
      //   bgColor: const Color.fromARGB(255, 240, 249, 255),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const CgPaymentScreen()),
      //   ),
      // ),
      _MenuOption(
        icon: Icons.notifications_outlined,
        label: "Notifications",
        iconColor: const Color(0xFF8B5CF6),
        bgColor: const Color(0xFFF5F3FF),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        ),
      ),
      _MenuOption(
        icon: Icons.star_outline,
        label: "My Ratings",
        iconColor: AppColors.orange,
        bgColor: const Color.fromARGB(255, 255, 251, 235),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProviderReviewsScreen()),
        ),
      ),
     
    ];

    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 245, 249),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: const Color(0x1A000000), offset: const Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: const Color(0x1A000000), offset: const Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        children: List.generate(options.length, (index) {
          return Column(
            children: [
              _MenuOptionTile(option: options[index]),
              if (index < options.length - 1)
                Divider(
                  height: 1.h,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16,
                  color: const Color(0xFFE5E7EB),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuOption {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _MenuOption({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });
}

class _MenuOptionTile extends StatelessWidget {
  final _MenuOption option;

  const _MenuOptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: option.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: option.bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(option.icon, size: 18.r, color: option.iconColor),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 14.sp,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.r, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
