import 'package:ehtemam_final_project/features/earnings_screen/data/repo/earnings_repo.dart';
import 'package:ehtemam_final_project/features/earnings_screen/manager/state/earning_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/transaction_repo.dart';
class EarningsCubit
    extends Cubit<EarningsState> {

  final EarningsRepository repository;
  EarningsCubit(this.repository)
      : super(EarningsInitial());

  Future<void> getEarnings() async {
    emit(EarningsLoading());

    try {
      final earnings =
      await repository.getEarnings();

      emit(
        EarningsLoaded(earnings),
      );
    } catch (e) {
      emit(
        EarningsError(
          e.toString(),
        ),
      );
    }
  }
}