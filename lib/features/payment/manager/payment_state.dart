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

  PaymentLoaded({
    required this.balance,
    required this.income,
    required this.expense,
    required this.transactions,
    required this.serviceCost,
    required this.platformFee,
    required this.taxRate,
    required this.total,
  });
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}