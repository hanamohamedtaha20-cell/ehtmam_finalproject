class PaymentModel {
  final double balance;
  final double income;
  final double expense;

  PaymentModel({
    required this.balance,
    required this.income,
    required this.expense,
  });
}

class TransactionModel {
  final String title;
  final double amount;
  final DateTime date;
  final String status;
  final bool isIncome; // true = green +, false = red -

  const TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.isIncome,
  });
}