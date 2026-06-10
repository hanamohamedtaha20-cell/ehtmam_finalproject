import '../model/cg_payment_model.dart';

class CgPaymentRepo {
  Future<Map<String, dynamic>> getEarningsData() async {
    await Future.delayed(const Duration(seconds: 1));

    final transactions = [
      CgTransactionModel(id: 'PAY00123456', clientName: 'Sarah Ahmed', serviceType: 'Pet Care', date: '2026-04-05', amount: 520.00, status: 'COMPLETED'),
      CgTransactionModel(id: 'PAY00223456', clientName: 'Mina Mamdouh', serviceType: 'Elderly Care', date: '2026-04-04', amount: 481.50, status: 'COMPLETED'),
      CgTransactionModel(id: 'PAY00323456', clientName: 'Wael Ashraf', serviceType: 'Child Care', date: '2026-04-03', amount: 5150.00, status: 'PENDING'),
    ];

    return {
      'totalEarned': 5950.00,
      'pending': 530.00,
      'transactions': transactions,
    };
  }
}