import '../data/model/complaint_model.dart';

abstract class ComplaintState {}

class ComplaintInitial extends ComplaintState {}

class ComplaintSubmitting extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  final ComplaintResponse response;
  ComplaintSuccess(this.response);
}

class ComplaintError extends ComplaintState {
  final String message;
  ComplaintError(this.message);
}
