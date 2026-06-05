import 'package:flutter/material.dart';

class WalletHeader extends StatelessWidget {
  final double balance; // 👈 ضيفي ده

  const WalletHeader({super.key, required this.balance}); // 👈 عدلي ده

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 مهم
      children: [
        /// 🔹 ICON BOX
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),

        const SizedBox(width: 10),

       
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Balance",
              style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 14,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              balance.toStringAsFixed(2),
              style: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}