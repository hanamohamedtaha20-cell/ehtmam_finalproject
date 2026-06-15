import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const PrimaryButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF432DD7).withOpacity(0.3),
              offset: Offset(0, 6),
              blurRadius: 10.r,
            ),
          ],
          color: Colors.blue,

          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8.w),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
