
import 'package:ehtemam_final_project/features/payment/data/model/payment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final double balance;
  final double income;
  final double expense;
  final List<TransactionModel> transactions;
  final double serviceCost;
  final double platformFee;
  final double taxRate;
  final double total;
  final double originalPrice;
  final double discountAmount;
  final String? bundleUsed;
  final int remainingSessions;

  PaymentLoaded({
    required this.balance,
    required this.income,
    required this.expense,
    required this.transactions,
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
    this.originalPrice = 0,
    this.discountAmount = 0,
    this.bundleUsed,
    this.remainingSessions = 0,
  });

  bool get hasBundleDiscount => bundleUsed != null || discountAmount > 0;

  PaymentLoaded copyWith({
    double? balance,
    double? income,
    double? expense,
    List<TransactionModel>? transactions,
    double? serviceCost,
    double? platformFee,
    double? taxRate,
    double? total,
    double? originalPrice,
    double? discountAmount,
    String? bundleUsed,
    int? remainingSessions,
  }) {
    return PaymentLoaded(
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transactions: transactions ?? this.transactions,
      serviceCost: serviceCost ?? this.serviceCost,
      platformFee: platformFee ?? this.platformFee,
      taxRate: taxRate ?? this.taxRate,
      total: total ?? this.total,
      originalPrice: originalPrice ?? this.originalPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      bundleUsed: bundleUsed ?? this.bundleUsed,
      remainingSessions: remainingSessions ?? this.remainingSessions,
    );
  }
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}