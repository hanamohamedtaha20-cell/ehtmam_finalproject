import 'package:flutter/material.dart';

class RechargeModel {
  final List<String> methods;
  final List<int> quickAmounts;

  RechargeModel({
    required this.methods,
    required this.quickAmounts,
  });
}

class PaymentMethodModel {
  final IconData icon;
  final String title;
  final String subtitle;

  const PaymentMethodModel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<PaymentMethodModel> paymentMethods = [
  const PaymentMethodModel(icon: Icons.credit_card, title: "Credit/Debit Card", subtitle: "Pay with card"),
];