import 'package:ehtemam_final_project/features/home_screen/ui/widgets/whyChoose_card.dart';
import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  final double total;
  final VoidCallback? onPay;

  const PayButton({super.key, required this.total, this.onPay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A8BD7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Pay ${total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}