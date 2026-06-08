import 'package:ehtemam_final_project/features/payment/data/model/payment_model.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionHistory({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: const [
              Text(
                "\$",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3A8BD7),
                ),
              ),
              SizedBox(width: 4),
              Text(
                "Transaction History",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // List
          Column(
            children: transactions
                .map((t) => Column(
                      children: [
                        TransactionItem(transaction: t),
                        const Divider(),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

