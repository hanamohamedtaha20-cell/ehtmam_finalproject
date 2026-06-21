import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'contact_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactButton extends StatelessWidget {
  final String name;
  final String speciality;
  final String phoneNumber;

  const ContactButton({
    super.key,
    required this.name,
    required this.speciality,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => showContactDialog(
          context,
          name: name,
          speciality: speciality,
          phoneNumber: phoneNumber,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF3A8BD7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contact_phone, color: Colors.white, size: 18.r),
              SizedBox(width: 6.w),
              Text('contact'.tr(),
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}