import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;

  const AdminTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10.r,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBack)
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.r,
                color: Color(0xff1F2937),
              ),
            ),
          if (showBack) SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff111827),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 26.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: const Color(0xffF3F7FB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.language, size: 14.r, color: Color(0xff64748B)),
                SizedBox(width: 4.w),
                Text(
                  'ع',
                  style: TextStyle(
                    color: Color(0xff64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}