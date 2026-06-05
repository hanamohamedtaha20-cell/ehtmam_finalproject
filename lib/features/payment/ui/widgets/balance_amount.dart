import 'package:flutter/material.dart';

class BalanceAmount extends StatelessWidget {
  final double balance;

  const BalanceAmount({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Text(
      balance.toStringAsFixed(2),
      style: const TextStyle(
        fontFamily: "Arimo",
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}