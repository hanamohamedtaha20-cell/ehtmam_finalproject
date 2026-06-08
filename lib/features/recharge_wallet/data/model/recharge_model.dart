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
  const PaymentMethodModel(icon: Icons.phone_android, title: "Vodafone Cash", subtitle: "Pay via Vodafone Cash"),
  const PaymentMethodModel(icon: Icons.account_balance, title: "InstaPay", subtitle: "Instant bank transfer"),
  const PaymentMethodModel(icon: Icons.credit_card, title: "Credit/Debit Card", subtitle: "Pay with card"),
  const PaymentMethodModel(icon: Icons.currency_exchange, title: "Fawry", subtitle: "Pay via Fawry"),
];