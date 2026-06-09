
import '../data/model/hc_request_model.dart';

abstract class HcHomeState {}

class HcHomeInitial extends HcHomeState {}

class HcHomeLoaded extends HcHomeState {
  final bool isAvailable;
  final List<HcRequestModel> requests;

  HcHomeLoaded({
    required this.isAvailable,
    required this.requests,
  });
}