import 'package:ehtemam_final_project/core/network/api_services.dart';
class PaymentRepo {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getPaymentData(String walletId) async {
    final result = await _api.getWalletById(walletId);
    return result;
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
}