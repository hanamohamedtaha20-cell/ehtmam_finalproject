import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/complaint_model.dart';


class ComplaintDetailsDialog extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailsDialog({
    super.key,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status.toLowerCase() == 'resolved';

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Color(0xff2F93E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Complaint Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
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

                  SizedBox(height: 12.h),

                  Text(
                    complaint.title,
                    style: TextStyle(
                      color: Color(0xff1E293B),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.25.h,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Category: ${complaint.category}',
                    style: TextStyle(
                      color: Color(0xff64748B),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailsText(
                          title: 'Complainant',
                          value:
                          '${complaint.fromName} (${complaint.fromRole})',
                        ),
                        SizedBox(height: 10.h),
                        _detailsText(
                          title: 'Against',
                          value:
                          '${complaint.againstName} (${complaint.againstRole})',
                        ),
                        SizedBox(height: 10.h),
                        _detailsText(
                          title: 'Date Submitted',
                          value: complaint.date,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xff334155),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(13.r),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFBEA),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xffFACC15),
                      ),
                    ),
                    child: Text(
                      complaint.description,
                      style: TextStyle(
                        color: Color(0xff334155),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsText({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xff64748B),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Color(0xff1E293B),
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}