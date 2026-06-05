import '../../data/model/model.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsSuccess extends RequestsState {

  final List<RequestModel> requests;

  RequestsSuccess(this.requests);
}

class RequestsError extends RequestsState {

  final String message;

  RequestsError(this.message);
}