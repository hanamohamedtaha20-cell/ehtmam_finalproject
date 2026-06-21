import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientBudgetCard extends StatelessWidget {
  final String amount;
  final String label;

  const ClientBudgetCard({
    super.key,
    required this.amount,
    this.label = "CLIENT'S BUDGET",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 22.h,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.r,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 16.r,
                color: Colors.grey.shade600,
              ),

              SizedBox(width: 6.w),

              Text(
                label,

                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Container(
            width: double.infinity,

            padding: EdgeInsets.symmetric(
              horizontal: 13.w,
              vertical: 13.h,
            ),

            decoration: BoxDecoration(
              color: Color(0xFFEAF8EE),

              borderRadius:
              BorderRadius.circular(14.r),
            ),

            child: Text(
              amount,

              style: TextStyle(
                color: Color(0xFF00A86B),
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}