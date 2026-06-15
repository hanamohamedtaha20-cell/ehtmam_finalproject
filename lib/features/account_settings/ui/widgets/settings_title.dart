import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color iconBgColor;
  final Color titleColor;
  final bool showArrow;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor = const Color(0xFF6BAEF5),
    this.iconBgColor = const Color(0xFFEAF4FF),
    this.titleColor = const Color(0xFF1D2939),
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16.r,
            offset: Offset(0, 6),
          ),
        ],
      ),
     child: Material(
  color: Colors.transparent,
  borderRadius: BorderRadius.circular(18.r),
  child: ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: iconBgColor,
      child: Icon(icon, color: iconColor, size: 20.r),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: titleColor,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w400,
        color: Color(0xFF98A2B3),
      ),
    ),
    trailing: showArrow
        ? Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14.r,
            color: Color(0xFF475467),
          )
        : null,
  ),
),
    );
  }
}