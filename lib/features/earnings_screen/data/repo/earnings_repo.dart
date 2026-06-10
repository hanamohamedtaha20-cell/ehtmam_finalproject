import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/transaction_model.dart';

class EarningsRepository {
  final ApiService _apiService;

  EarningsRepository(this._apiService);

  Future<EarningsResult> getEarnings() async {
    final response = await _apiService.getMyBookings();
    final bookings = _extractDataList(response);

    double totalEarnings = 0;
    int jobs = 0;
    int totalHours = 0;
    final transactions = <TransactionModel>[];

    for (final b in bookings) {
      final map = b as Map<String, dynamic>;
      final rawStatus = (map['status'] ?? '').toString().toUpperCase();
      final transaction = TransactionModel.fromBookingJson(map);
      final price = transaction.amount;
      final request = map['request'];

      if (rawStatus == 'COMPLETED') {
        totalEarnings += price;
        jobs++;
      }

      if (request is Map) {
        totalHours += _parseDurationHours(request['duration']?.toString() ?? '');
      }

      if (rawStatus == 'COMPLETED' ||
          rawStatus == 'CONFIRMED' ||
          rawStatus == 'PENDING') {
        transactions.add(transaction);
      }
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));

    final avgJob = jobs > 0 ? (totalEarnings / jobs).round() : 0;

    return EarningsResult(
      earnings: EarningsModel(
        totalEarnings: totalEarnings,
        jobs: jobs,
        avgJob: avgJob,
        hoursWorked: totalHours,
      ),
      transactions: transactions,
    );
  }

  int _parseDurationHours(String duration) {
    final match = RegExp(r'(\d+)').firstMatch(duration.toLowerCase());
    if (match == null) return 0;
    final value = int.tryParse(match.group(1) ?? '') ?? 0;
    if (duration.toLowerCase().contains('day')) {
      return value * 8;
    }
    return value;
  }

  List<dynamic> _extractDataList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      final data = response['data'];
      if (data is List) return data;
    }
    return [];
  }
}
