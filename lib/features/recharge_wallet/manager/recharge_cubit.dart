import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/recharge_repo.dart';
import '../data/model/recharge_model.dart';
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
      // CARD or MOBILE_WALLET بناءً على الاختيار
      final methodMap = {
        0: 'MOBILE_WALLET', // Vodafone Cash
        1: 'MOBILE_WALLET', // InstaPay
        2: 'CARD',          // Credit/Debit Card
        3: 'MOBILE_WALLET', // Fawry
      };

      final paymentMethod = methodMap[selectedMethodIndex] ?? 'CARD';

      final result = await repo.recharge(
        amount: amount,
        paymentMethod: paymentMethod,
      );

      if (result['success'] == true) {
        emit(RechargeSuccess(result['paymentUrl']));
      } else {
        emit(RechargeError(result['message'] ?? 'حدث خطأ'));
      }
    } catch (e) {
      emit(RechargeError('تعذر الاتصال بالسيرفر'));
    }
  }
}