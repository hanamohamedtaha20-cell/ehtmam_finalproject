import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/register_screen.dart';
import 'package:ehtemam_final_project/features/login_required_screen/ui/widgets/pirmary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../home_screen/ui/screens/home_screen.dart';
import 'outline_bottom.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginRequiredCard extends StatelessWidget {
  const LoginRequiredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20.r,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset("assets/images/lock90.png", height: 90.h),
            SizedBox(height: 10.h),

            Text('login_required'.tr(),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 10.h),

            /// 🔹 Description
            Text('login_to_create_requests'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20.h),

            /// 🔹 Info box
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Color(0xFFF1F3F8),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Text('guest_browse_notice'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// 🔹 Login Button
            PrimaryButton(
              text: "Login to Continue",
              icon: Icons.login,
              onTap: () {
                 Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),

            SizedBox(height: 10.h),

            /// 🔹 Create Account
            OutlineButton(
              text: "Create Account",
              icon: Icons.person_add,
              onTap: () {
                 Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(role: '',)),
                );
              },
            ),

            SizedBox(height: 10.h),

            /// 🔹 Back
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('back_to_home'.tr(),
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
