class CgTransactionModel {
  final String id;
  final String clientName;
  final String serviceType;
  final String date;
  final double amount;
  final String status;
  final String type;

  CgTransactionModel({
    required this.id,
    required this.clientName,
    required this.serviceType,
    required this.date,
    required this.amount,
    required this.status,
    this.type = '',
  });

  factory CgTransactionModel.fromJson(Map<String, dynamic> json) {
    // client is an object: { "_id": "...", "full_name": "..." }
    final clientObj = json['client'];
    final clientName = clientObj is Map
        ? (clientObj['full_name']?.toString() ?? '')
        : '';

    // serviceName is a top-level string field (not nested under service)
    final serviceType = json['serviceName']?.toString() ??
        (json['service'] is Map
            ? (json['service']['serviceName']?.toString() ?? '')
            : '');

    // date field is createdAt
    final raw = json['createdAt']?.toString() ?? json['date']?.toString() ?? '';
    final date = _formatDate(raw);

    // amount field (not price)
    final amount =
        ((json['amount'] ?? json['price'] ?? 0) as num).toDouble();

    return CgTransactionModel(
      id:          json['_id']?.toString() ?? '',
      clientName:  clientName,
      serviceType: serviceType,
      date:        date,
      amount:      amount,
      status:      json['status']?.toString() ?? 'PENDING',
      type:        json['type']?.toString() ?? '',
    );
  }

  static String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
