import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/transaction_model.dart';

class EarningsRepository {
  final ApiService _apiService;

  EarningsRepository(this._apiService);

  Future<EarningsModel> getEarnings() async {
    final response = await _apiService.getMyBookings();
    final List bookings = response['data'] ?? [];

    double totalEarnings = 0;
    int jobs = bookings.length;

    for (final b in bookings) {
      totalEarnings += (b['price'] ?? 0).toDouble();
    }

    final avgJob = jobs > 0 ? (totalEarnings / jobs).round() : 0;

    return EarningsModel(
      totalEarnings: totalEarnings,
      jobs: jobs,
      avgJob: avgJob,
      hoursWorked: 0,
    );
  }
}