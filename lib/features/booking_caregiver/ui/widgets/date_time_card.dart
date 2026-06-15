import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimeCard extends StatelessWidget {
  final String date;
  final String time;
  final String location;

  const DateTimeCard({
    super.key,
    this.date = '',
    this.time = '',
    this.location = '',
  });

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              icon,
              color: const Color(0xff2F80ED),
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff6B7A90),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: TextStyle(
                    color: Color(0xff1F2C44),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff4B5A75),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "DATE & TIME",
                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          infoItem(
            icon: Icons.calendar_month_outlined,
            title: "Date",
            value: date,
          ),
          infoItem(
            icon: Icons.access_time_outlined,
            title: "Time",
            value: time,
          ),
          infoItem(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: location,
          ),
        ],
      ),
    );
  }
}
