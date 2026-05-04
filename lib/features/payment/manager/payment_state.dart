abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final double balance;
  final double income;
  final double expense;

  PaymentLoaded({
    required this.balance,
    required this.income,
    required this.expense,
  });
}