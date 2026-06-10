
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repo/payment_repo.dart';
import '../data/model/payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  Future<void> loadData({double? offerPrice}) async {
    final currentBalance = state is PaymentLoaded
        ? (state as PaymentLoaded).balance
        : 0.0;
    emit(PaymentLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookingId = prefs.getString('bookingId') ?? '';

      double price = offerPrice ?? 0;

      if (bookingId.isNotEmpty) {
        try {
          final bookingResult = await repo.getBookingData(bookingId);
          final bookingData = bookingResult['data'];
          if (bookingData is Map<String, dynamic>) {
            price = _extractPrice(bookingData, fallback: price);
          }
        } catch (_) {
          // Fall back to offer price when booking details are unavailable.
        }
      }

      final double platformFee = price * 0.05;
      final double taxRate = price * 0.14;
      final double total = price + platformFee + taxRate;

      emit(PaymentLoaded(
        balance: currentBalance,
        income: 0,
        expense: 0,
        transactions: [],
        serviceCost: price,
        platformFee: platformFee,
        taxRate: taxRate,
        total: total,
      ));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<String?> payBooking() async {
    final current = state;
    if (current is! PaymentLoaded) {
      return 'Payment data is not ready';
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final bookingId = prefs.getString('bookingId') ?? '';

      if (bookingId.isEmpty) {
        return 'No booking selected for payment';
      }

      await repo.payBooking(bookingId);

      emit(current.copyWith(
        balance: current.balance - current.total,
        expense: current.expense + current.total,
      ));
      return null;
    } catch (e) {
      return e.toString();
    }
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