import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/cg_payment_model.dart';

class CgPaymentRepo {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getTransactionDetails(String id) async {
    return await _api.getTransactionDetails(id);
  }

  Future<Map<String, dynamic>> getEarningsData() async {
    double balance     = 0;
    double totalEarned = 0;
    double pending     = 0;
    List<CgTransactionModel> transactions = [];

    try {
      // Correct endpoint: GET /wallet/my-wallet
      // Response shape: { status, data: { balance, holdBalance, totalEarned,
      //                                   totalDeposited, totalSpent,
      //                                   transactions: [...] } }
      final result     = await _api.getMyWallet();
      final walletData = result['data'];

      if (walletData is Map) {
        balance = ((walletData['balance'] ?? 0) as num).toDouble();

        // pending / held amount that has not been released yet
        pending = ((walletData['holdBalance'] ??
                walletData['pendingBalance'] ??
                walletData['pending'] ??
                0) as num)
            .toDouble();

        totalEarned = ((walletData['totalEarned'] ??
                walletData['total_earned'] ??
                0) as num)
            .toDouble();

        final txRaw = walletData['transactions'];
        if (txRaw is List) {
          final txItems = txRaw.whereType<Map<String, dynamic>>().toList();
          txItems.sort((a, b) {
            final aStr = a['createdAt']?.toString() ?? a['_id']?.toString() ?? '';
            final bStr = b['createdAt']?.toString() ?? b['_id']?.toString() ?? '';
            return bStr.compareTo(aStr);
          });
          transactions = txItems.map(CgTransactionModel.fromJson).toList();
        }
      }

      debugPrint('[CgPaymentRepo] balance=$balance  totalEarned=$totalEarned  '
          'holdBalance=$pending  transactions=${transactions.length}');
    } catch (e) {
      debugPrint('[CgPaymentRepo] wallet fetch failed: $e');
    }

    return {
      'balance':      balance,
      'totalEarned':  totalEarned,
      'pending':      pending,
      'transactions': transactions,
    };
  }
}
