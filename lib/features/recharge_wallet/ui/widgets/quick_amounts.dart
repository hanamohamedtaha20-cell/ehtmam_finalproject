import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickAmounts extends StatelessWidget {
  final double selectedAmount;
  final ValueChanged<double> onSelected;

  const QuickAmounts({
    super.key,
    required this.selectedAmount,
    required this.onSelected,
  });

  static const List<double> _amounts = [50, 100, 200, 500];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _amounts.map((amount) {
        final isSelected = selectedAmount == amount;
        return GestureDetector(
          onTap: () => onSelected(amount),
          child: Container(
            width: 70.w,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  color: isSelected ? AppColors.blue : Colors.grey.shade300),
              boxShadow: [
                BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
              ],
            ),
            child: Center(
              child: Text(
                amount.toInt().toString(),
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}