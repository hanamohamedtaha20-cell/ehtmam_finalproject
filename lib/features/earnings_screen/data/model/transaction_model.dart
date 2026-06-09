class TransactionModel {
  final String title;
  final String clientName;
  final double amount;
  final String date;
  final String status;

  TransactionModel({
    required this.title,
    required this.clientName,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'] ?? '',
      clientName: json['clientName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory TransactionModel.fromBookingJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];
    final offer = json['offer'];
    final client = request is Map ? request['client'] : null;

    String serviceName = 'Care Service';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? serviceName;
    }

    String clientName = '';
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
    }

    final rawStatus = (json['status'] ?? '').toString().toUpperCase();
    final isPaid = rawStatus == 'COMPLETED' || rawStatus == 'CONFIRMED';
    final amount = (offer?['price'] ?? json['price'] ?? 0).toDouble();
    final date = request is Map ? (request['date']?.toString() ?? '') : '';

    return TransactionModel(
      title: serviceName,
      clientName: clientName,
      amount: amount,
      date: date,
      status: isPaid ? 'Paid' : 'Pending',
    );
  }
}

class EarningsModel {
  final double totalEarnings;
  final int jobs;
  final int avgJob;
  final int hoursWorked;

  EarningsModel({
    required this.totalEarnings,
    required this.jobs,
    required this.avgJob,
    required this.hoursWorked,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      jobs: json['jobs'] ?? 0,
      avgJob: json['avgJob'] ?? 0,
      hoursWorked: json['hoursWorked'] ?? 0,
    );
  }
}

class EarningsResult {
  final EarningsModel earnings;
  final List<TransactionModel> transactions;

  EarningsResult({
    required this.earnings,
    required this.transactions,
  });
}
