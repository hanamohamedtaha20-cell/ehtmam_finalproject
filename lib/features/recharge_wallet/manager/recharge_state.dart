import 'package:ehtemam_final_project/features/recharge_wallet/data/model/recharge_model.dart';

abstract class RechargeState {}

class RechargeInitial extends RechargeState {}

class RechargeLoading extends RechargeState {}

class RechargeLoaded extends RechargeState {
  final RechargeModel model;
  RechargeLoaded(this.model);
}

// لما الـ API يرجع الـ paymentUrl
class RechargeSuccess extends RechargeState {
  final String paymentUrl;
  RechargeSuccess(this.paymentUrl);
}

class RechargeError extends RechargeState {
  final String message;
  RechargeError(this.message);
}