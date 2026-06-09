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
      final prefs     = await SharedPreferences.getInstance();
      final walletId  = prefs.getString('walletId')  ?? '';
      final bookingId = prefs.getString('bookingId') ?? '';

      //final walletResult  = await repo.getPaymentData(walletId);
      final bookingResult = await repo.getBookingData(bookingId);

      // final walletData  = walletResult['data'];
      final bookingData = bookingResult['data'];

      final double price       = (bookingData?['price'] ?? 0).toDouble();
      final double platformFee = price * 0.05;
      final double taxRate     = price * 0.10;
      final double total       = price + platformFee + taxRate;

      // final transactions = (walletData['transactions'] as List? ?? [])
      //     .map((t) => TransactionModel.fromJson(t))
      //     .toList();

      emit(PaymentLoaded(
        balance:      ( 0).toDouble(),
        income:       ( 0).toDouble(),
        expense:      ( 0).toDouble(),
        transactions: [],
        serviceCost:  price,
        platformFee:  platformFee,
        taxRate:      taxRate,
        total:        total,
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