import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

void showContactDialog(
  BuildContext context, {
  required String name,
  required String speciality,
  required String phoneNumber,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text('contact_caregiver'.tr(),
        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 32.r),
          ),
          SizedBox(height: 12.h),
          Text(name,
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp)),
          Text(speciality,
              style: TextStyle(
                  fontFamily: "Arimo", fontSize: 12.sp, color: Colors.grey)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: Color(0xFF3A8BD7), size: 18.r),
              SizedBox(width: 8.w),
              Text(phoneNumber,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('close'.tr(),
              style: TextStyle(fontFamily: "Arimo", color: Colors.grey)),
        ),
      ],
    ),
  );
}