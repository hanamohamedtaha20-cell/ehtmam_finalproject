import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final String status =
    transaction.status.toLowerCase();

    Color statusBg;
    Color statusText;
    Color amountColor;

    if (status == 'completed') {
      statusBg = const Color(0xffD1FAE5);
      statusText = const Color(0xff059669);
      amountColor = const Color(0xff00A86B);
    } else if (status == 'refunded') {
      statusBg = const Color(0xffDBEAFE);
      statusText = const Color(0xff2563EB);
      amountColor = const Color(0xff2563EB);
    } else {
      statusBg = const Color(0xffFEF3C7);
      statusText = const Color(0xffD97706);
      amountColor = const Color(0xffD97706);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.clientName,
                  style: TextStyle(
                    color: Color(0xff111827),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  transaction.status,
                  style: TextStyle(
                    color: statusText,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                transaction.amount.toString(),
                style: TextStyle(
                  color: amountColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              transaction.bundleName.isNotEmpty
                  ? transaction.bundleName
                  : transaction.type,
              style: TextStyle(
                color: Color(0xff334155),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 5.h),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12.r,
                color: Color(0xff94A3B8),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  transaction.transactionDate,
                  style: TextStyle(
                    color: Color(0xff64748B),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),

          Divider(height: 22.h),

          Row(
            children: [
              Expanded(
                child: _NameInfo(
                  icon: Icons.person_outline,
                  label: 'Client:',
                  name: transaction.clientName,
                  iconColor: const Color(0xff2F80ED),
                ),
              ),
              Expanded(
                child: _NameInfo(
                  icon: Icons.person_outline,
                  label: 'Caregiver:',
                  name: transaction.caregiverName,
                  iconColor: const Color(0xff00A86B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NameInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String name;
  final Color iconColor;

  const _NameInfo({
    required this.icon,
    required this.label,
    required this.name,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13.r,
          color: iconColor,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    color: Color(0xff334155),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: name,
                  style: TextStyle(
                    color: Color(0xff334155),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}