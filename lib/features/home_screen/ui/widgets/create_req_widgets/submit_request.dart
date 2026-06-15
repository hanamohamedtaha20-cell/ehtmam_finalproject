import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitRequest extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitRequest({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      height: 50.h,

      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r
          ),

          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF8EC5FC),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6.r,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: ElevatedButton.icon(
          onPressed: onSubmit,

          icon: Icon(
            Icons.send_outlined,
            color: Colors.white,
            size: 18.r,
          ),

          label: Text(
            "Submit Request",

            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.r),
            ),
          ),
        ),
      ),
    );
  }
}