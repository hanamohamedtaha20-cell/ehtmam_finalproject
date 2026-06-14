import '../../data/transaction_model.dart';

enum TransactionsStatus {
  initial,
  loading,
  success,
  error,
}

class TransactionsState {
  final TransactionsStatus status;

  final List<TransactionModel> transactions;

  final String searchText;

  final String errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.searchText = '',
    this.errorMessage = '',
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionModel>? transactions,
    String? searchText,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      searchText: searchText ?? this.searchText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}