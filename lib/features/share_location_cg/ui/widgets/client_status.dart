import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientStatus extends StatelessWidget {
  final String status;
  final String statusSubtitle;

  const ClientStatus({
    super.key,
    required this.status,
    required this.statusSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 15.r),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black)),
                Text(statusSubtitle, style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.black45)),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.access_time, color: Colors.blue, size: 15.r),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('arriving_soon'.tr(), style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black)),
                Text("Expected in 15 min.", style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}