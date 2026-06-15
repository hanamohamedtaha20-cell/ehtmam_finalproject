import 'package:ehtemam_final_project/features/home_screen/ui/widgets/whyChoose_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayButton extends StatelessWidget {
  final double total;
  final VoidCallback? onPay;

  const PayButton({super.key, required this.total, this.onPay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPay,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A8BD7),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "Pay ${total.toStringAsFixed(2)}",
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}