import 'package:ehtemam_final_project/features/payment/data/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final amountText =
        "${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}";
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    final bgColor = isIncome
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          // Icon
          CircleAvatar(
            radius: 20,
            backgroundColor: bgColor,
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(width: 10.w),
          // Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${_monthName(transaction.date.month)} ${transaction.date.day}, ${transaction.date.year}",
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 11.sp,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          // Amount & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: color,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                transaction.status,
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11.sp,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}