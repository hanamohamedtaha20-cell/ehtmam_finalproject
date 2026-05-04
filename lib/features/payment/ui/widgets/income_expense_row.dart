import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class IncomeExpenseRow extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpenseRow({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
         child: _card(
          title: "Total Added",
          amount: income,
          color: Colors.white,
          icon: Image.asset(
           "assets/images/Container9.png",
            width: 24,
            height: 24,
            fit: BoxFit.contain,

          ),
        ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _card(
          title: "Total Spent",
          amount: expense,
          color: Colors.white,
          icon: Image.asset(
            "assets/images/Container13.png",
            width: 24,
            height: 24,
            fit: BoxFit.contain,

          ),
        ),
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required double amount,
    required Color color,
    required Widget icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
         boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: icon,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount.toStringAsFixed(2),
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}