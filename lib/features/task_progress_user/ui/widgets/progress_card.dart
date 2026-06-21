import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'status_chip.dart';
import 'package:easy_localization/easy_localization.dart';

class ProgressCard extends StatelessWidget {
  final double progressValue;
  final String progressPercent;
  final int completedCount;
  final int totalCount;
  final String workingStatus;
  final String checkInTime;

  const ProgressCard({
    super.key,
    required this.progressValue,
    required this.progressPercent,
    required this.completedCount,
    required this.totalCount,
    this.workingStatus = '',
    this.checkInTime = '',
  });

  @override
  Widget build(BuildContext context) {
    final statusText = workingStatus.isNotEmpty
        ? workingStatus
        : 'Caregiver is currently working';
    final checkInText = checkInTime.isNotEmpty
        ? 'Checked in at $checkInTime'
        : 'Not checked in yet';

    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A8BD7), Color(0xFF5A9FE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('task_progress'.tr(),
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('progress'.tr(),
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13.sp,
                        color: Colors.white70),
                  ),
                  Text(
                    progressPercent,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$completedCount/$totalCount tasks",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12.sp,
                        color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                StatusChip(
                  icon: Icons.circle,
                  text: statusText,
                  iconColor: const Color(0xFF4CAF50),
                ),
                SizedBox(height: 6.h),
                StatusChip(
                  icon: Icons.location_pin,
                  text: checkInText,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff00A63E)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
