import 'package:flutter/material.dart';

import 'transaction_card.dart';

class RecentTransactionsSection
    extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Transactions",
            ),

        SizedBox(height: 14),

            TransactionCard(
              title: "Pet Care",
              subtitle: "marina tarik",
              amount: "550",
              date: "March 7, 2026",
              status: "Paid",
            ),
      ],
    );
  }
}