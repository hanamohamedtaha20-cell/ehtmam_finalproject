class CgTransactionModel {
  final String id;
  final String clientName;
  final String serviceType;
  final String date;
  final double amount;
  final String status;
  final String type;
  final double grossAmount;
  final double platformFee;
  final double netAmount;
  final String duration;
  final String location;

  CgTransactionModel({
    required this.id,
    required this.clientName,
    required this.serviceType,
    required this.date,
    required this.amount,
    required this.status,
    this.type = '',
    this.grossAmount = 0,
    this.platformFee = 0,
    this.netAmount = 0,
    this.duration = '',
    this.location = '',
  });

  factory CgTransactionModel.fromJson(Map<String, dynamic> json) {
    final clientObj = json['client'];
    final clientName = clientObj is Map
        ? (clientObj['full_name']?.toString() ?? '')
        : '';

    final serviceType = json['serviceName']?.toString() ??
        (json['service'] is Map
            ? (json['service']['serviceName']?.toString() ?? '')
            : '');

    final raw = json['createdAt']?.toString() ?? json['date']?.toString() ?? '';
    final date = _formatDate(raw);

    final amount =
        ((json['amount'] ?? json['price'] ?? 0) as num).toDouble();

    final grossAmount =
        ((json['grossAmount'] ?? json['amount'] ?? 0) as num).toDouble();
    final platformFee =
        ((json['platformFee'] ?? json['platform_fee'] ?? 0) as num).toDouble();
    final netAmount = ((json['netAmount'] ??
            json['netEarnings'] ??
            json['net_earnings'] ??
            0) as num)
        .toDouble();

    final bookingObj = json['booking'];
    final booking =
        bookingObj is Map ? Map<String, dynamic>.from(bookingObj) : null;

    final duration = json['duration']?.toString() ??
        booking?['duration']?.toString() ??
        '';
    final location = json['location']?.toString() ??
        booking?['location']?.toString() ??
        booking?['governorate']?.toString() ??
        '';

    return CgTransactionModel(
      id: json['_id']?.toString() ?? '',
      clientName: clientName,
      serviceType: serviceType,
      date: date,
      amount: amount,
      status: json['status']?.toString() ?? 'PENDING',
      type: json['type']?.toString() ?? '',
      grossAmount: grossAmount,
      platformFee: platformFee,
      netAmount: netAmount,
      duration: duration,
      location: location,
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
