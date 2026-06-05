import '../../data/model/provider_data.dart';

abstract class ProviderState {}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProviderLoaded extends ProviderState {
  final ProviderModel provider;

  ProviderLoaded(this.provider);
}

class ProviderError extends ProviderState {}