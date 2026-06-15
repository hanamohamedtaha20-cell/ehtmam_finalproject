import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

    const StatusChip({
      super.key,
      required this.icon,
      required this.text,
      this.iconColor = const Color(0xFF3A8BD7),
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Icon(icon, color: iconColor, size: 16.r),        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
              fontFamily: "Arimo", fontSize: 12.sp, color: Color(0xFF3A8BD7)),
        ),
      ],
    );
  }
}