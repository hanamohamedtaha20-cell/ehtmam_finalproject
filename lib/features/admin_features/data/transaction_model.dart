class TransactionModel {
  final String id;
  final String clientName;
  final double amount;
  final String status;
  final String type;
  final String caregiverName;
  final String bundleName;
  final String transactionDate;

  TransactionModel({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.type,
    required this.caregiverName,
    required this.bundleName,
    required this.transactionDate,
  });

  factory TransactionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionModel(
      id: json['transactionId']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['transactionStatus']?.toString() ?? '',
      type: json['transactionType']?.toString() ?? '',
      caregiverName: json['caregiverName']?.toString() ?? '',
      bundleName: json['bundleName']?.toString() ?? '',
      transactionDate: json['transactionDate']?.toString() ?? '',
    );
  }
}