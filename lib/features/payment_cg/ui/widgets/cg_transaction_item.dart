import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/cg_payment_model.dart';
import '../../manager/cg_payment_cubit.dart';
import 'transaction_details_sheet.dart';
import 'package:easy_localization/easy_localization.dart';

class CgTransactionItem extends StatelessWidget {
  final CgTransactionModel transaction;

  const CgTransactionItem({super.key, required this.transaction});

  Color get _statusColor {
    switch (transaction.status.toUpperCase()) {
      case 'COMPLETED': return const Color.fromARGB(255, 18, 120, 204);
      case 'PENDING':return Colors.orange;
      default: return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (transaction.status.toUpperCase()) {
      case 'COMPLETED': return 'Completed';
      case 'PENDING': return 'Pending';
      default: return transaction.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(61, 0, 0, 0), blurRadius: 6.r, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 24.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.clientName, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    Text(transaction.serviceType, style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.black87)),
                    Text(transaction.date, style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Colors.black87)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(color: Color(0xff3A8BD7)  ,fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(height: 5.h),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: _statusColor, size: 12.r),
                        SizedBox(width: 4.w),
                        Text(_statusLabel, style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: _statusColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaction ID: ${transaction.id.substring(0, 8)}',
                  style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Colors.black87)),
              GestureDetector(
                onTap: () {
                  final cubit = context.read<CgPaymentCubit>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r)),
                    ),
                    builder: (_) => BlocProvider.value(
                      value: cubit,
                      child: TransactionDetailsSheet(
                          transaction: transaction),
                    ),
                  );
                },
                child: Text('view_details_arrow'.tr(),
                    style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Color(0xFF3A8BD7))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}