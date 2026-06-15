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
    if (isClosed) return;
    emit(RechargeLoading());
    try {
      const paymentMethod = 'CARD';
      final result = await repo.recharge(
        amount: amount,
        paymentMethod: paymentMethod,
      );
      if (!isClosed) {
        final data = result['data'] is Map ? result['data'] as Map : result;
        final url = data['iframeUrl']?.toString()
            ?? data['paymentUrl']?.toString()
            ?? data['redirectUrl']?.toString()
            ?? result['iframeUrl']?.toString()
            ?? result['paymentUrl']?.toString()
            ?? '';
        emit(RechargeSuccess(url));
      }
    } catch (e) {
      if (!isClosed) {
        emit(RechargeError('failed to connect to the sevrver'));
      }
    }
  }
}
