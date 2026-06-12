
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repo/payment_repo.dart';
import '../data/model/payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  Future<void> loadData() async {
    emit(PaymentLoading());
    try {
      final walletResult = await repo.getPaymentData('');
      final walletData = walletResult['data'];

      final double balance = (walletData?['balance'] ?? 0).toDouble();
      final double income  = (walletData?['totalDeposited'] ?? 0).toDouble();
      final double expense = (walletData?['totalSpent'] ?? 0).toDouble();

      final transactions = (walletData?['transactions'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((t) => TransactionModel.fromJson(t))
          .toList();

      emit(PaymentLoaded(
        balance:      balance,
        income:       income,
        expense:      expense,
        transactions: transactions,
        serviceCost:  0,
        platformFee:  0,
        taxRate:      0,
        total:        0,
      ));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
  void addBalance(double amount) {
    if (state is PaymentLoaded) {
      final current = state as PaymentLoaded;
      emit(current.copyWith(
        balance: current.balance + amount,
      ));
    }
  }
}