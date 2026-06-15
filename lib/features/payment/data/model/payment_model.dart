class PaymentModel {
  final double balance;
  final double income;
  final double expense;

  PaymentModel({
    required this.balance,
    required this.income,
    required this.expense,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      balance: (json['balance'] ?? 0).toDouble(),
      income:  (json['totalDeposited'] ?? 0).toDouble(),
      expense: (json['totalSpent'] ?? 0).toDouble(),
    );
  }
}

class TransactionModel {
  final String title;
  final double amount;
  final DateTime date;
  final String status;
  final bool isIncome;

  const TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.isIncome,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title:    json['type']?.toString() ?? '',
      amount:   (json['amount'] ?? 0).toDouble(),
      date:     DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      status:   json['status']?.toString() ?? '',
      isIncome: json['type'] == 'DEPOSIT',
    );
  }
}