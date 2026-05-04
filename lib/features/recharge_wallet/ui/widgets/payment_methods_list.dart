import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/widgets/payment_method_item.dart';
import 'package:flutter/material.dart';

class PaymentMethodsList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PaymentMethodsList({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Column(
        children: List.generate(
          paymentMethods.length,
          (i) => PaymentMethodItem(
            method: paymentMethods[i],
            isSelected: selectedIndex == i,
            isLast: i == paymentMethods.length - 1,
            onTap: () => onSelected(i),
          ),
        ),
      ),
    );
  }
}