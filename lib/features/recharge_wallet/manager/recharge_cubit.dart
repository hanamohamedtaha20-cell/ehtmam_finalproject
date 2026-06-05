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
}