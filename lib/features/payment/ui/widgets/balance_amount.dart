import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceAmount extends StatelessWidget {
  final double balance;

  const BalanceAmount({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Text(
      balance.toStringAsFixed(2),
      style: TextStyle(
        fontFamily: "Arimo",
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}