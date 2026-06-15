class CgTransactionModel {
  final String id;
  final String clientName;
  final String serviceType;
  final String date;
  final double amount;
  final String status;

  CgTransactionModel({
    required this.id,
    required this.clientName,
    required this.serviceType,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory CgTransactionModel.fromJson(Map<String, dynamic> json) {
    return CgTransactionModel(
      id: json['_id']?.toString() ?? '',
      clientName: json['client'] is Map ? (json['client']['full_name']?.toString() ?? '') : '',
      serviceType: json['service'] is Map ? (json['service']['serviceName']?.toString() ?? '') : '',
      date: json['date']?.toString() ?? '',
      amount: (json['price'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'PENDING',
    );
  }
}