import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/cg_payment_repo.dart';
import 'cg_payment_state.dart';

class CgPaymentCubit extends Cubit<CgPaymentState> {
  final CgPaymentRepo repo;

  CgPaymentCubit(this.repo) : super(CgPaymentInitial());

  Future<void> loadData() async {
    emit(CgPaymentLoading());
    try {
      final data = await repo.getEarningsData();

      emit(CgPaymentLoaded(
        totalEarned: data['totalEarned'],
        pending: data['pending'],
        transactions: data['transactions'],
        balance: data['balance'],
      ));
    } catch (e) {
      emit(CgPaymentError(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> fetchTransactionDetails(String id) async {
    try {
      return await repo.getTransactionDetails(id);
    } catch (_) {
      return null;
    }
  }

  void filterBy(String filter) {
    if (state is CgPaymentLoaded) {
      final current = state as CgPaymentLoaded;
      emit(CgPaymentLoaded(
        totalEarned: current.totalEarned,
        pending: current.pending,
        transactions: current.transactions,
        balance: current.balance,
        filter: filter,
      ));
    }
  }
}