abstract class CreateRequestState {}

class CreateRequestInitial extends CreateRequestState {}

class CreateRequestLoading extends CreateRequestState {}

class CreateRequestSuccess extends CreateRequestState {}

class CreateRequestError extends CreateRequestState {
  final String message;
  CreateRequestError(this.message);
}