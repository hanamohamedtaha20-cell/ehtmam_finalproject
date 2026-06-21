

import '../../data/model/care_request.dart';

abstract class CareRequestsState {}

class CareRequestsUnavailable extends CareRequestsState {}

class CareRequestsInitial
    extends CareRequestsState {}

class CareRequestsLoading
    extends CareRequestsState {}

class CareRequestsLoaded
    extends CareRequestsState {
  final List<CareRequestModel> requests;

  CareRequestsLoaded(
      this.requests,
      );
}

class CareRequestsError
    extends CareRequestsState {
  final String message;

  CareRequestsError(
      this.message,
      );
}