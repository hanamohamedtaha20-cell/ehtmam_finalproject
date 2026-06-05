import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';

abstract class RechargeState {}

class RechargeInitial extends RechargeState {}

class RechargeLoaded extends RechargeState {
  final RechargeModel model;

  RechargeLoaded(this.model);
}