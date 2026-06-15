import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const PaymentMethodItem({
    super.key,
    required this.method,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSelected ? 16 : 0),
            topRight: Radius.circular(isSelected ? 16 : 0),
            bottomLeft: Radius.circular(isLast || isSelected ? 16 : 0),
            bottomRight: Radius.circular(isLast || isSelected ? 16 : 0),
          ),
          border: isSelected ? Border.all(color: AppColors.blue, width: 1.5.w) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(method.icon, size: 20.r,
                  color: isSelected ? Colors.white : AppColors.textLight),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.title,
                      style: TextStyle(
                          fontFamily: "Arimo",
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: isSelected ? AppColors.blue : AppColors.textDark)),
                  Text(method.subtitle,
                      style: TextStyle(
                          fontFamily: "Arimo",
                          fontSize: 11.sp,
                          color: AppColors.textLight)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.blue, size: 20.r),
          ],
        ),
      ),
    );
  }
}