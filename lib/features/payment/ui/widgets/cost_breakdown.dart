import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/pay_button.dart';
import 'package:easy_localization/easy_localization.dart';
// ─── Main Widget ───────────────────────────────────────────────────────────────
class CostBreakdown extends StatelessWidget {
  final double serviceCost;
  final double platformFee;
  final double taxRate;
  final double total;
  final double discountAmount;
  final String? bundleUsed;
  final int remainingSessions;
  final VoidCallback? onPay;

  const CostBreakdown({
    super.key,
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
    this.discountAmount = 0,
    this.bundleUsed,
    this.remainingSessions = 0,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return _CostBreakdownCard(
      serviceCost: serviceCost,
      platformFee: platformFee,
      taxRate: taxRate,
      total: total,
      discountAmount: discountAmount,
      bundleUsed: bundleUsed,
      remainingSessions: remainingSessions,
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
  final double discountAmount;
  final String? bundleUsed;
  final int remainingSessions;
  final VoidCallback? onPay;

  const _CostBreakdownCard({
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
    this.discountAmount = 0,
    this.bundleUsed,
    this.remainingSessions = 0,
    this.onPay,
  });

  bool get _hasDiscount => bundleUsed != null || discountAmount > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4.r,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x1A000000),
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
          if (_hasDiscount) ...[
            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: Row(
                children: [
                  Icon(Icons.discount_outlined,
                      color: const Color(0xFF2E7D32), size: 14.r),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'Your bundle discount has been applied.',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 12.sp,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Original price
            _CostBreakdownRow(
                label: 'Original Price', amount: serviceCost, isBold: false),
            // Discount row (shown as a saving)
            _CostBreakdownRow(
              label: 'Bundle Discount',
              amount: discountAmount,
              isBold: false,
              valueColor: const Color(0xFF2E7D32),
              isNegative: true,
            ),
            // Remaining sessions
            if (remainingSessions > 0)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('remaining_sessions'.tr(),
                      style: TextStyle(
                          fontFamily: 'Arimo', fontSize: 14.sp),
                    ),
                    Text(
                      '$remainingSessions',
                      style: TextStyle(
                          fontFamily: 'Arimo', fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            const Divider(),
            _CostBreakdownRow(
              label: 'Final Price',
              amount: total,
              isBold: true,
              color: Colors.black,
              valueColor: const Color(0xFF3A8BD7),
            ),
          ] else ...[
            _CostBreakdownRow(
                label: 'Service Cost', amount: serviceCost, isBold: false),
            _CostBreakdownRow(
                label: 'Platform Fee (5%)', amount: platformFee, isBold: false),
            _CostBreakdownRow(
                label: 'Tax (14%)', amount: taxRate, isBold: false),
            const Divider(),
            _CostBreakdownRow(
              label: 'Total Amount',
              amount: total,
              isBold: true,
              color: Colors.black,
              valueColor: const Color(0xFF3A8BD7),
            ),
          ],
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
    return Text('cost_breakdown'.tr(),
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
  final bool isNegative;
  final Color? color;
  final Color? valueColor;

  const _CostBreakdownRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.isNegative = false,
    this.color,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
        '${isNegative ? '-' : ''}${amount.toStringAsFixed(2)}';
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
            displayValue,
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

