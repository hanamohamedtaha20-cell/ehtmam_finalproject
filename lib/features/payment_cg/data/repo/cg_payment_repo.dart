import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/cg_payment_model.dart';

class CgPaymentRepo {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getEarningsData() async {
    final walletResult = await _api.getMyWallet();
    final walletData = walletResult['data'];

    final balance     = (walletData?['balance'] ?? 0).toDouble();
    final totalEarned = (walletData?['totalEarned'] ?? 0).toDouble();

    // مؤقتاً لحد ما نعرف نجيب transactions حقيقية
    final transactions = <CgTransactionModel>[];

    return {
      'totalEarned': totalEarned,
      'pending': 0.0,
      'transactions': transactions,
      'balance': balance,
    };
  }
}