import '../data/model/cg_payment_model.dart';

abstract class CgPaymentState {}

class CgPaymentInitial extends CgPaymentState {}

class CgPaymentLoading extends CgPaymentState {}

class CgPaymentLoaded extends CgPaymentState {
  final double totalEarned;
  final double pending;
  final List<CgTransactionModel> transactions;
  final String filter;

  CgPaymentLoaded({
    required this.totalEarned,
    required this.pending,
    required this.transactions,
    this.filter = 'All',
  });

  List<CgTransactionModel> get filteredTransactions {
    if (filter == 'All') return transactions;
    return transactions.where((t) => t.status.toUpperCase() == filter.toUpperCase()).toList();
  }
}

class CgPaymentError extends CgPaymentState {
  final String message;
  CgPaymentError(this.message);
}