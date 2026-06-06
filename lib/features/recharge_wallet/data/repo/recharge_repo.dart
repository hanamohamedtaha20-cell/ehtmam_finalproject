import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/recharge_model.dart';

class RechargeRepo {
  final ApiService _api = ApiService();

  RechargeModel getData() {
    return RechargeModel(
      methods: ["Vodafone Cash", "InstaPay", "Credit/Debit Card", "Fawry"],
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