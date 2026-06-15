import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final String status;
  final bool pending;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.status,
    this.pending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.r,
            offset: Offset(0,4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.r,
                      color: Colors.grey.shade500,
                    ),

                    SizedBox(width: 4.w),

                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              Text(
                amount,
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 8.h),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 5.h,
                ),

                decoration: BoxDecoration(
                  color: pending
                      ? const Color(0xFFFFF3CD)
                      : const Color(0xFFE8F5E9),

                  borderRadius:
                  BorderRadius.circular(20.r),
                ),

                child: Text(
                  status,
                  style: TextStyle(
                    color: pending
                        ? const Color(0xFFE68A00)
                        : const Color(0xFF2E7D32),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}