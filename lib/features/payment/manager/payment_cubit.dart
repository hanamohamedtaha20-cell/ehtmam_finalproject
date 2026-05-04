import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/payment_repo.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  void loadData() {
    final data = repo.getPaymentData();

    emit(
      PaymentLoaded(
        balance: data.balance,
        income: data.income,
        expense: data.expense,
      ),
    );
  }
}