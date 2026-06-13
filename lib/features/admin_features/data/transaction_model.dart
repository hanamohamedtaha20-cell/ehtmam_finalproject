class TransactionModel {
  final String id;
  final String service;
  final String amount;
  final String status;
  final String userName;
  final String providerName;

  TransactionModel({
    required this.id,
    required this.service,
    required this.amount,
    required this.status,
    required this.userName,
    required this.providerName,
  });
}