import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/manager/state/provider_state.dart';
import '../data/repo/Provider_repo.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final ProviderRepository repo;

  ProviderCubit(this.repo) : super(ProviderInitial());

  Future<void> getOffers(String requestId) async {
    if (isClosed) return;
    emit(ProviderLoading());

    try {
      final offers = await repo.getOffers(requestId);

      if (!isClosed) {
        if (offers.isEmpty) {
          emit(ProviderEmpty());
          return;
        }

        emit(ProviderLoaded(offers: offers));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProviderError(e.toString()));
      }
    }
  }

  Future<void> loadOfferDetails({
    required String requestId,
    required String offerId,
  }) async {
    if (isClosed) return;
    emit(ProviderLoading());

    try {
      final offers = await repo.getOffers(requestId);

      if (!isClosed) {
        if (offers.isEmpty) {
          emit(ProviderEmpty());
          return;
        }

        final selected = offers.firstWhere(
          (offer) => offer.id == offerId,
          orElse: () => offers.first,
        );

        emit(ProviderLoaded(offers: offers, selectedOffer: selected));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProviderError(e.toString()));
      }
    }
  }
}
