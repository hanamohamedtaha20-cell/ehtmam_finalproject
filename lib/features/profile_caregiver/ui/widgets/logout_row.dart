import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutRow extends StatelessWidget {
  const LogoutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Container(
        margin: EdgeInsets.all(12.r),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color.fromARGB(109, 244, 67, 54)),
          boxShadow: [
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 18.r),
            SizedBox(width: 8.w),
            Text(
              "Logout",
              style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthCubit>().logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
}
