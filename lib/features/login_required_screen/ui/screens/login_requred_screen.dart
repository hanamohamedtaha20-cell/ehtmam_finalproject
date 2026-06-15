import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/login_required_card.dart';

class LoginRequiredScreen extends StatelessWidget {
  const LoginRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F6FA),

      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFFE8F3FF),
              Color(0xFFF7FBFF),
            ],
          ),
        ),
        child: Column(
          children: [
             SizedBox(height: 20.h),

            /// 🔹 Guest text
             Padding(padding: EdgeInsets.symmetric(horizontal: 16.w)),

             SizedBox(height: 20.h),

            /// 🔹 Card
            Expanded(child: Center(child: LoginRequiredCard())),

            Padding(
              padding:  EdgeInsets.only(bottom: 16.h),
              child: Text(
                "Join CareConnect to access all features".tr(),
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
