import 'package:ehtemam_final_project/features/earnings_screen/data/repo/earnings_repo.dart';
import 'package:ehtemam_final_project/features/earnings_screen/manager/state/earning_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final EarningsRepository repository;

  EarningsCubit(this.repository) : super(EarningsInitial());

  Future<void> getEarnings() async {
    emit(EarningsLoading());

    try {
      final result = await repository.getEarnings();
      emit(EarningsLoaded(
        result.earnings,
        transactions: result.transactions,
      ));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }
}
