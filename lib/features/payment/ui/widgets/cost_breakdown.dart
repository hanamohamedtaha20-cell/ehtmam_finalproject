import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/pay_button.dart';
// ─── Main Widget ───────────────────────────────────────────────────────────────
class CostBreakdown extends StatelessWidget {
  final double serviceCost;
  final double platformFee;
  final double taxRate;
  final double total;
  final VoidCallback? onPay;

  const CostBreakdown({
    super.key,
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return _CostBreakdownCard(
      serviceCost: serviceCost,
      platformFee: platformFee,
      taxRate: taxRate,
      total: total,
      onPay: onPay,
    );
  }
}

// ─── Card Container ────────────────────────────────────────────────────────────
class _CostBreakdownCard extends StatelessWidget {
  final double serviceCost;
  final double platformFee;
  final double taxRate;
  final double total;
  final VoidCallback? onPay;

  const _CostBreakdownCard({
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // #000000 10%
            offset: Offset(0, 2),
            blurRadius: 4.r,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x1A000000), // #000000 10%
            offset: Offset(0, 4),
            blurRadius: 6.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CostBreakdownTitle(),
          SizedBox(height: 10.h),
         _CostBreakdownRow(label: "Service Cost", amount: serviceCost, isBold: false),
        _CostBreakdownRow(label: "Platform Fee (5%)", amount: platformFee, isBold: false),
        _CostBreakdownRow(label: "Tax (14%)", amount: taxRate, isBold: false),
        Divider(),
        _CostBreakdownRow(
          label: "Total Amount",
          amount: total,
          isBold: true,
          color: Colors.black,
          valueColor: const Color(0xFF3A8BD7)
        ),
          SizedBox(height: 16.h),
          PayButton(total: total, onPay: onPay),
        ],
      ),
    );
  }
}

// ─── Title ─────────────────────────────────────────────────────────────────────
class _CostBreakdownTitle extends StatelessWidget {
  const _CostBreakdownTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Cost Breakdown",
      style: TextStyle(
        fontFamily: "Arimo",
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }
}

// ─── Row ───────────────────────────────────────────────────────────────────────
class _CostBreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final Color? color;
  final Color? valueColor;

  const _CostBreakdownRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.color,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
              color: color,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
              color: valueColor ?? color,
            ),
          ),
        ],
      ),
    );
  }
}

