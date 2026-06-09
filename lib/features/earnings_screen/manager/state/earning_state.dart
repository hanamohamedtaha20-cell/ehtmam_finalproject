import '../../data/model/transaction_model.dart';

abstract class EarningsState {}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final EarningsModel earnings;

  EarningsLoaded(this.earnings);
}

class EarningsError extends EarningsState {
  final String message;

  EarningsError(this.message);
}