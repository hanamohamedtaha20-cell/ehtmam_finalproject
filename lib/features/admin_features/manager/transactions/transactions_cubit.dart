import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../data/transaction_model.dart';
import 'transactions_state.dart';

class TransactionsCubit
    extends Cubit<TransactionsState> {
  final ApiService apiService;

  TransactionsCubit({
    ApiService? apiService,
  }) : apiService = apiService ?? ApiService(),
        super(const TransactionsState());

  List<TransactionModel> _allTransactions = [];

  Future<void> getTransactions() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: TransactionsStatus.loading,
      ),
    );

    try {
      final transactions =
      await apiService.getAllTransactions();

      _allTransactions = transactions..sort((a, b) => b.id.compareTo(a.id));

      if (!isClosed) {
        emit(
          state.copyWith(
            status: TransactionsStatus.success,
            transactions: _allTransactions,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: TransactionsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void searchTransactions(
      String value,
      ) {
    final query =
    value.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          transactions: _allTransactions,
          searchText: value,
        ),
      );
      return;
    }

    final filtered =
    _allTransactions.where((transaction) {
      return transaction.id
          .toLowerCase()
          .contains(query) ||
          transaction.clientName
              .toLowerCase()
              .contains(query) ||
          transaction.caregiverName
              .toLowerCase()
              .contains(query) ||
          transaction.type
              .toLowerCase()
              .contains(query);
    }).toList();

    emit(
      state.copyWith(
        transactions: filtered,
        searchText: value,
      ),
    );
  }
}
