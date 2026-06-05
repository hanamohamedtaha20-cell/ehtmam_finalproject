import '../model/payment_model.dart';

class PaymentRepo {
  PaymentModel getPaymentData() {
    return PaymentModel(
      balance: 1450.50,
      income: 1700.00,
      expense: 632.50,
    );
  }
}