import 'package:ehtemam_final_project/features/payment/ui/widgets/add_funds.dart';
import 'package:flutter/material.dart';
import 'wallet_header.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
       gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A8BD7),
            Color(0xFF5A9FE0),
            Color(0xFFD8E3E9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WalletHeader(balance: balance),
          const SizedBox(height: 6),
          const SizedBox(height: 10),
          const AddFundsButton(),
        ],
      ),
    );
  }
}