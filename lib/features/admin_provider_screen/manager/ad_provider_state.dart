import '../model/ad_provider_model.dart';

abstract class AdProviderState {}

class AdProviderInitial extends AdProviderState {}

class AdProviderLoading extends AdProviderState {}

class AdProviderLoaded extends AdProviderState {
  final List<AdProviderModel> allProviders;
  final List<AdProviderModel> providers;
  final String searchText;

  AdProviderLoaded({
    required this.allProviders,
    required this.providers,
    this.searchText = '',
  });
}

class AdProviderError extends AdProviderState {
  final String message;

  AdProviderError(this.message);
}