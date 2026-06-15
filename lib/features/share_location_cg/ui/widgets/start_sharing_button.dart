import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartSharingButton extends StatelessWidget {
  final bool isSharing;
  final VoidCallback onTap;

  const StartSharingButton({
    super.key,
    required this.isSharing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 8.w, right: 8.w),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSharing ? Colors.red : const Color(0xFF1F9E0E),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSharing ? Icons.stop : Icons.share, color: Colors.white, size: 18.r),
              SizedBox(width: 6.w),
              Text(
                isSharing ? "Stop Sharing Location" : "Start Sharing Location",
                style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}