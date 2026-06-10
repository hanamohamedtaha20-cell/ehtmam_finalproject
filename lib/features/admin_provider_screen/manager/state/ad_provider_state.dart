import '../../model/ad_provider_model.dart';

abstract class AdProviderState {}

class AdProviderInitial
    extends AdProviderState {}

class AdProviderLoading
    extends AdProviderState {}

class AdProviderLoaded
    extends AdProviderState {
  final List<AdProviderModel> providers;

  AdProviderLoaded(this.providers);
}

class AdProviderError
    extends AdProviderState {
  final String message;

  AdProviderError(this.message);
}