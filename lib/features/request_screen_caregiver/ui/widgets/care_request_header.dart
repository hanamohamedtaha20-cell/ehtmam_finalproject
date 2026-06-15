import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestHeader extends StatelessWidget {
  const RequestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 18.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20.r,
                  color: Color(0xFF222222),
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                "Care Requests",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          /// LANGUAGE BUTTON
          Row(
            children: [
               LanguageSwitcher(),
              ],
            ),
        ],
      ),
    );
  }
}