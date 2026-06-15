
import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/payment_repo.dart';
import '../data/model/payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  Future<void> loadData({double? offerPrice}) async {
    if (isClosed) return;
    emit(PaymentLoading());

    double balance = 0;
    double income = 0;
    double expense = 0;
    List<TransactionModel> transactions = [];

    try {
      final walletResult = await repo.getPaymentData('');

      // Backend may nest wallet under 'data' or 'data.wallet'
      final raw = walletResult['data'];
      final walletData = (raw is Map && raw['wallet'] is Map)
          ? raw['wallet'] as Map
          : raw as Map?;

      balance = _parseDouble(walletData, const [
        'balance', 'currentBalance', 'current_balance', 'amount',
      ]);
      income = _parseDouble(walletData, const [
        'totalDeposited', 'total_deposited', 'totalAdded', 'income',
      ]);
      expense = _parseDouble(walletData, const [
        'totalSpent', 'total_spent', 'totalWithdrawn', 'expense',
      ]);

      final txRaw = walletData?['transactions']
          ?? walletData?['history']
          ?? walletResult['transactions']
          ?? [];
      transactions = (txRaw as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((t) => TransactionModel.fromJson(t))
          .toList();

      // Derive balance from transactions when the field is missing or zero.
      if (balance == 0 && transactions.isNotEmpty) {
        for (final t in transactions) {
          if (t.isIncome) {
            balance += t.amount;
            income += t.amount;
          } else {
            balance -= t.amount;
            expense += t.amount;
          }
        }
      }
    } catch (_) {
      // Wallet may not exist yet — show summary with zero balance.
    }

    final double price = offerPrice ?? 0;
    final double platformFee = price * 0.05;
    final double taxRate = price * 0.14;
    final double total = price + platformFee + taxRate;

    if (!isClosed) {
      emit(PaymentLoaded(
        balance: balance,
        income: income,
        expense: expense,
        transactions: transactions,
        serviceCost: price,
        platformFee: platformFee,
        taxRate: taxRate,
        total: total,
      ));
    }
  }

  // Payment was already processed by the backend when the offer was accepted.
  // This screen is a confirmation summary — nothing left to charge.
  Future<String?> payBooking() async {
    if (state is! PaymentLoaded) return 'Payment data is not ready';
    return null;
  }

  Future<String?> payBundlePurchase(String bundleId) async {
    if (state is! PaymentLoaded) return 'Payment data is not ready';
    try {
      await repo.payBundle(bundleId);
      return null;
    } catch (e) {
      return apiErrorMessage(e);
    }
  }

  static double _parseDouble(Map? data, List<String> keys) {
    if (data == null) return 0;
    for (final key in keys) {
      final val = data[key];
      if (val is num && val != 0) return val.toDouble();
    }
    return 0;
  }

  double _extractPrice(Map<String, dynamic> bookingData, {double fallback = 0}) {
    final offer = bookingData['offer'];
    if (offer is Map) {
      final offerPrice = offer['price'];
      if (offerPrice is num) return offerPrice.toDouble();
    }

    final price = bookingData['price'];
    if (price is num) return price.toDouble();

    return fallback;
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
