import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomeExpenseRow extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpenseRow({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
         child: _card(
          title: "Total Added",
          amount: income,
          color: Colors.white,
          icon: Image.asset(
           "assets/images/Container9.png",
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,

          ),
        ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _card(
          title: "Total Spent",
          amount: expense,
          color: Colors.white,
          icon: Image.asset(
            "assets/images/Container13.png",
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,

          ),
        ),
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required double amount,
    required Color color,
    required Widget icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
         boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          offset: Offset(0, 2),
          blurRadius: 4.r,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          offset: Offset(0, 4),
          blurRadius: 6.r,
          spreadRadius: 0,
        ),
      ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: icon,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}