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

  factory TransactionModel.fromJson(
      Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'] ?? '',
      clientName: json['clientName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
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

  factory EarningsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EarningsModel(
      totalEarnings:
      (json['totalEarnings'] ?? 0).toDouble(),
      jobs: json['jobs'] ?? 0,
      avgJob: json['avgJob'] ?? 0,
      hoursWorked: json['hoursWorked'] ?? 0,
    );
  }
}