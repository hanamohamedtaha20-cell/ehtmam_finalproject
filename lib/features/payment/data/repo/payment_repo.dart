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

  /// Accepts the offer AND deducts wallet in one call.
  /// Used when the user manually confirms payment from PaymentScreen.
  Future<Map<String, dynamic>> processOfferPayment(String offerId) async {
    return await _api.processPayment(offerId);
  }

  Future<Map<String, dynamic>> payBundle(String bundleId) async {
    return await _api.payBundle(bundleId);
  }

  Future<Map<String, dynamic>> payExtraTask(String taskId, {String? bookingId}) async {
    return await _api.payExtraTask(taskId, bookingId: bookingId);
  }
}