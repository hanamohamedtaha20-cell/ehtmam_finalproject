import '../../data/model/service_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ServiceModel> services;

  HomeSuccess(this.services);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}