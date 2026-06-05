import '../model/recharge_model.dart';

class RechargeRepo {
  RechargeModel getData() {
    return RechargeModel(
      methods: [
        "Vodafone Cash",
        "InstaPay",
        "Credit/Debit Card",
        "Fawry",
      ],
      quickAmounts: [50, 100, 200, 500],
    );
  }
}