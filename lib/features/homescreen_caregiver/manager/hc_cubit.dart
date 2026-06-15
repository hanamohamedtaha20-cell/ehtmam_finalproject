import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/earnings_screen/data/model/transaction_model.dart';
import 'package:ehtemam_final_project/features/earnings_screen/data/repo/earnings_repo.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/repo/repository_implementation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hc_state.dart';

class HcCubit extends Cubit<HcState> {
  final CareRequestsRepositoryImpl _requestsRepo;
  final EarningsRepository _earningsRepo;

  HcCubit({
    CareRequestsRepositoryImpl? requestsRepo,
    EarningsRepository? earningsRepo,
  })  : _requestsRepo =
            requestsRepo ?? CareRequestsRepositoryImpl(ApiService()),
        _earningsRepo = earningsRepo ?? EarningsRepository(ApiService()),
        super(const HcState());

  Future<void> loadDashboard() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('user_name') ?? prefs.getString('userName') ?? 'Caregiver';
      final requests = await _requestsRepo.getAllRequests();
      final pending = requests
          .where((request) => request.status == 'Pending')
          .toList();
      final accepted = requests
          .where((r) => r.status == 'Accepted' || r.status == 'Completed' || r.status == 'In Progress')
          .toList();
      final earningsResult = await _earningsRepo.getEarnings();
      final weekEarnings = _earningsThisWeek(earningsResult.transactions);
      final hours = earningsResult.earnings.hoursWorked;
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          userName: userName,
          requestsToday: pending.length,
          earningsThisWeek: weekEarnings,
          activeHours: '${hours}h',
          pendingRequests: pending,
          acceptedBookings: accepted,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void toggleAvailability(bool value) {
    emit(state.copyWith(isAvailable: value));
  }

  Future<void> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    try {
      await _requestsRepo.respondToRequest(
        requestId: requestId,
        action: action,
      );
      await loadDashboard();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  int _earningsThisWeek(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    var total = 0.0;
    for (final transaction in transactions) {
      if (transaction.status != 'Paid') continue;

      final parsed = DateTime.tryParse(transaction.date);
      if (parsed == null) continue;

      if (!parsed.isBefore(weekStart)) {
        total += transaction.amount;
      }
    }
    return total.round();
  }
}
