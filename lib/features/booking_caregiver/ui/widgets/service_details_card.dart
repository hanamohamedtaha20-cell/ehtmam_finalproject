import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDetailsCard extends StatelessWidget {
  final String serviceType;
  final String petType;
  final String duration;

  const ServiceDetailsCard({
    super.key,
    this.serviceType = '',
    this.petType = '',
    this.duration = '',
  });

  Widget detailRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xff4B5A75),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Color(0xff1F2C44),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
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
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
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
                Icons.inventory_2_outlined,
                color: Color(0xff4B5A75),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "SERVICE DETAILS",
                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          detailRow(
            title: "Service Type",
            value: serviceType.isNotEmpty ? serviceType : '—',
          ),
          if (petType.isNotEmpty)
            detailRow(
              title: "Notes",
              value: petType,
            ),
          detailRow(
            title: "Duration",
            value: duration.isNotEmpty ? duration : '—',
          ),
        ],
      ),
    );
  }
}
