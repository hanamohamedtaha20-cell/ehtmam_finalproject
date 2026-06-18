import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/cg_payment_model.dart';

class CgPaymentRepo {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getEarningsData() async {
    double balance = 0;
    double totalEarned = 0;
    double pending = 0;
    List<CgTransactionModel> transactions = [];

    // Fetch wallet — use GET /wallet (my-wallet returns 404 on this backend)
    try {
      final walletResult = await _api.getWalletById('');
      final walletData = walletResult['data'];
      if (walletData is Map) {
        balance = (walletData['balance'] ?? 0).toDouble();
        totalEarned = (walletData['totalEarned'] ?? walletData['total_earned'] ?? 0).toDouble();
        pending = (walletData['pending'] ?? walletData['pendingAmount'] ?? 0).toDouble();
      }
    } catch (e) {
      debugPrint('CgPaymentRepo: wallet fetch failed: $e');
    }

    return {
      'totalEarned': totalEarned,
      'pending': pending,
      'transactions': transactions,
      'balance': balance,
    };
  }
}
