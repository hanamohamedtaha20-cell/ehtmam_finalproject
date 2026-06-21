import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class HcPendingRequestsHeader extends StatelessWidget {
  final int pendingCount;

  const HcPendingRequestsHeader({
    super.key,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Padding(
      padding: EdgeInsets.fromLTRB(16 * s, 20 * s, 16 * s, 12 * s),
      child: Row(
        children: [
          Text('new_care_requests'.tr(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0B2B5A),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8EC),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$pendingCount pending',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
