import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/features/earnings_screen/data/model/transaction_model.dart';
import 'transaction_card.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecentTransactionsSection({
    super.key,
    this.transactions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Transactions"),
        SizedBox(height: 14.h),
        if (transactions.isEmpty)
          Text(
            'No transactions yet',
            style: TextStyle(color: Colors.grey.shade600),
          )
        else
          ...transactions.map(
            (t) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: TransactionCard(
                title: t.title,
                subtitle: t.clientName,
                amount: t.amount.toStringAsFixed(0),
                date: t.date,
                status: t.status,
                pending: t.status.toLowerCase() == 'pending',
              ),
            ),
          ),
      ],
    );
  }
}
