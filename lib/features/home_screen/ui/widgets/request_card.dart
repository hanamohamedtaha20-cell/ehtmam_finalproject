import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final String description;
  final String provider;

  const RequestCardWidget({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.description,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, right: 8.w, left: 8.w),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5.r)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 6.h),
                Text(
                  description.tr(),
                  style:  TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                 SizedBox(height: 6.h),
                Text(
                  "starts".tr(args: [date]),
                  style:  TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),

                SizedBox(height: 6.h),

                Text(
                  provider.isEmpty ? "" : "provider".tr(args: [provider]),
                  style: TextStyle(fontSize: 12.sp, color: Color(0xFF39DAF6)),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      status.tr(),
                      style: TextStyle(color: statusColor, fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}