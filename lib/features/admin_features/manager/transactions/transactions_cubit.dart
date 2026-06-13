import 'package:bloc/bloc.dart';
import 'package:ehtmam_finalproject/features/admin_features/manager/transactions/transactions_state.dart';

class TransactionsCubit
    extends Cubit<TransactionsState> {

  TransactionsCubit()
      : super(const TransactionsState());

  Future<void> getTransactions() async {}

  void searchTransactions(String value) {}
}