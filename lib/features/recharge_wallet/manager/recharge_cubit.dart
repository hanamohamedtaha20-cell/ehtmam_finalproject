import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/recharge_repo.dart';
import 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final RechargeRepo repo;

  RechargeCubit(this.repo) : super(RechargeInitial());

  void loadData() {
    final data = repo.getData();
    emit(RechargeLoaded(data));
  }

  Future<void> recharge({
    required double amount,
    required int selectedMethodIndex,
  }) async {
    emit(RechargeLoading());
    try {
      final paymentMethod = 'CARD';

      print('RECHARGE REQUEST: amount=$amount, method=$paymentMethod');
      final result = await repo.recharge(
        amount: amount,
        paymentMethod: paymentMethod,
      );
      emit(RechargeSuccess(result['paymentUrl'] ?? ''));
      print('PAYMENT URL: ${result['paymentUrl']}');
      emit(RechargeSuccess(result['paymentUrl'] ?? ''));
    } catch (e) {
      emit(RechargeError('failed to connect to the sevrver'));
    }
  }
}