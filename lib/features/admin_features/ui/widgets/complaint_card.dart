import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/complaint_model.dart';


class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback onViewDetails;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status.toLowerCase() == 'resolved';

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8.r,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: isResolved
                  ? const Color(0xffDCFCE7)
                  : const Color(0xffFEF3C7),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              complaint.status,
              style: TextStyle(
                color: isResolved
                    ? const Color(0xff16A34A)
                    : const Color(0xffF59E0B),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            complaint.title,
            style: TextStyle(
              color: Color(0xff1E293B),
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              height: 1.25.h,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Category: ${complaint.category}',
            style: TextStyle(
              color: Color(0xff64748B),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          _infoRow(
            icon: Icons.person_outline,
            iconColor: Color(0xff2F93E6),
            text:
            'From: ${complaint.fromName} (${complaint.fromRole})',
          ),
          SizedBox(height: 5.h),
          _infoRow(
            icon: Icons.error_outline,
            iconColor: Colors.red,
            text:
            'Against: ${complaint.againstName} (${complaint.againstRole})',
          ),
          SizedBox(height: 5.h),
          _infoRow(
            icon: Icons.access_time,
            iconColor: Color(0xff64748B),
            text: complaint.date,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 34.h,
            child: ElevatedButton.icon(
              onPressed: onViewDetails,
              icon: Icon(Icons.remove_red_eye_outlined, size: 14.r),
              label: Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEEF4FF),
                foregroundColor: const Color(0xff2F93E6),
                elevation: 0,
                textStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14.r, color: iconColor),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xff334155),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}