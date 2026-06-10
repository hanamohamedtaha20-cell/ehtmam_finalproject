import '../../data/model/provider_data.dart';

abstract class ProviderState {}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProviderLoaded extends ProviderState {
  final List<ProviderModel> offers;
  final ProviderModel? selectedOffer;

  ProviderLoaded({
    required this.offers,
    this.selectedOffer,
  });

  ProviderModel get provider {
    if (selectedOffer != null) return selectedOffer!;
    if (offers.isNotEmpty) return offers.first;
    throw StateError('No offers available');
  }
}

class ProviderEmpty extends ProviderState {}

class ProviderError extends ProviderState {
  final String message;

  ProviderError([this.message = 'Failed to load data']);
}
