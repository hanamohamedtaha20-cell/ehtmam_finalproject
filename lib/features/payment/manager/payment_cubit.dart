
import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/payment_repo.dart';
import '../data/model/payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  Future<void> loadData({
    double? offerPrice,
    double? originalPrice,
    double? discountAmount,
    String? bundleUsed,
    int? remainingSessions,
  }) async {
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
      final txItems = (txRaw as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();
      txItems.sort((a, b) {
        final aStr = a['createdAt']?.toString() ?? a['_id']?.toString() ?? '';
        final bStr = b['createdAt']?.toString() ?? b['_id']?.toString() ?? '';
        return bStr.compareTo(aStr);
      });
      transactions = txItems.map((t) => TransactionModel.fromJson(t)).toList();

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

    final bool hasDiscount = (discountAmount ?? 0) > 0 || bundleUsed != null;
    final double price = offerPrice ?? 0;
    final double origPrice = originalPrice ?? price;
    final double discount = discountAmount ?? 0;
    final double platformFee = hasDiscount ? 0 : price * 0.05;
    final double taxRate = hasDiscount ? 0 : price * 0.14;
    final double total = hasDiscount ? price : price + platformFee + taxRate;

    debugPrint('ACTIVE_BUNDLE: ${bundleUsed ?? "none"}');
    debugPrint('ORIGINAL_PRICE: $origPrice');
    debugPrint('DISCOUNT_AMOUNT: $discount');
    debugPrint('FINAL_PRICE: $price');
    debugPrint('REMAINING_BUNDLE_SESSIONS: ${remainingSessions ?? 0}');

    if (!isClosed) {
      emit(PaymentLoaded(
        balance: balance,
        income: income,
        expense: expense,
        transactions: transactions,
        serviceCost: origPrice,
        platformFee: platformFee,
        taxRate: taxRate,
        total: total,
        originalPrice: origPrice,
        discountAmount: discount,
        bundleUsed: bundleUsed,
        remainingSessions: remainingSessions ?? 0,
      ));
    }
  }

  /// Processes payment for a regular booking offer.
  /// Calls processPayment(offerId) which deducts wallet + creates booking server-side.
  Future<String?> payBooking(String offerId) async {
    if (state is! PaymentLoaded) return 'Payment data is not ready';
    if (offerId.trim().isEmpty) return 'Offer ID is missing';
    try {
      await repo.processOfferPayment(offerId.trim());
      return null;
    } catch (e) {
      return apiErrorMessage(e);
    }
  }

  /// Charges the user's wallet for a caregiver-added extra task.
  Future<String?> payExtraTask(String taskId, {String? bookingId}) async {
    if (state is! PaymentLoaded) return 'Payment data is not ready';
    debugPrint('[ExtraTask] payExtraTask taskId=$taskId bookingId=$bookingId');
    try {
      await repo.payExtraTask(taskId, bookingId: bookingId);
      return null;
    } catch (e) {
      return apiErrorMessage(e);
    }
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

  void addBalance(double amount) {
    if (state is PaymentLoaded) {
      final current = state as PaymentLoaded;
      emit(current.copyWith(
        balance: current.balance + amount,
      ));
    }
  }
}
