import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSelected ? 16 : 0),
            topRight: Radius.circular(isSelected ? 16 : 0),
            bottomLeft: Radius.circular(isLast || isSelected ? 16 : 0),
            bottomRight: Radius.circular(isLast || isSelected ? 16 : 0),
          ),
          border: isSelected ? Border.all(color: AppColors.blue, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(method.icon, size: 20,
                  color: isSelected ? Colors.white : AppColors.textLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.title,
                      style: TextStyle(
                          fontFamily: "Arimo",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? AppColors.blue : AppColors.textDark)),
                  Text(method.subtitle,
                      style: const TextStyle(
                          fontFamily: "Arimo",
                          fontSize: 11,
                          color: AppColors.textLight)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}