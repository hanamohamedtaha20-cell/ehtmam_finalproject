import 'package:ehtemam_final_project/features/payment/data/model/payment_model.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionHistory extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionHistory({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4.r,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Text(
                "\$",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Color(0xFF3A8BD7),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "Transaction History",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // List
          Column(
            children: transactions
                .map((t) => Column(
                      children: [
                        TransactionItem(transaction: t),
                        Divider(),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

