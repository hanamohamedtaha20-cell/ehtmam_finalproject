import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';


class RechargeRepo {
  final ApiService _api = ApiService();

  RechargeModel getData() {
    return RechargeModel(
      methods: ["Credit/Debit Card"],
      quickAmounts: [50, 100, 200, 500],
    );
  }

  Future<Map<String, dynamic>> recharge({
    required double amount,
    required String paymentMethod,
  }) async {
    return await _api.createPayment(
      amount: amount,
      paymentMethod: paymentMethod,
    );
  }
}