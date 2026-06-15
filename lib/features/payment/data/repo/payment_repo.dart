import 'package:ehtemam_final_project/core/network/api_service.dart';

class PaymentRepo {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getPaymentData(String walletId) async {
    return await _api.getWalletById(walletId);
  }

  Future<Map<String, dynamic>> getBookingData(String bookingId) async {
    return await _api.getBookingById(bookingId);
  }

  Future<Map<String, dynamic>> rechargeWallet({
    required double amount,
    required String paymentMethod,
  }) async {
    return await _api.createPayment(
      amount: amount,
      paymentMethod: paymentMethod,
    );
  }

  Future<Map<String, dynamic>> payBooking(String bookingId) async {
    return await _api.payBookingFromWallet(bookingId);
  }

  Future<Map<String, dynamic>> payBundle(String bundleId) async {
    return await _api.payBundle(bundleId);
  }
}