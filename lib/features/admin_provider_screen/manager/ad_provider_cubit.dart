import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ad_provider_model.dart';
import '../model/repo/ad_provider_repo.dart';
import 'state/ad_provider_state.dart';

class AdProviderCubit extends Cubit<AdProviderState> {
  final AdProviderRepository repository;

  AdProviderCubit(this.repository)
      : super(AdProviderInitial());

  List<AdProviderModel> providers = [];

  Future<void> getProviders() async {
    try {
      emit(AdProviderLoading());

      providers =
      await repository.getProviders();

      emit(
        AdProviderLoaded(providers),
      );
    } catch (e) {
      emit(
        AdProviderError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> blockProvider(
      int providerId,
      ) async {
    try {
      await repository.blockProvider(
        providerId,
      );

      providers = providers.map((provider) {
        if (provider.id == providerId) {
          return provider.copyWith(
            isActive: false,
          );
        }

        return provider;
      }).toList();

      emit(
        AdProviderLoaded(
          providers,
        ),
      );
    } catch (e) {
      emit(
        AdProviderError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> searchProviders(
      String query,
      ) async {
    try {
      if (query.isEmpty) {
        emit(
          AdProviderLoaded(
            providers,
          ),
        );
        return;
      }

      final filteredProviders =
      providers.where((provider) {
        return provider.name
            .toLowerCase()
            .contains(
          query.toLowerCase(),
        ) ||
            provider.email
                .toLowerCase()
                .contains(
              query.toLowerCase(),
            ) ||
            provider.service
                .toLowerCase()
                .contains(
              query.toLowerCase(),
            );
      }).toList();

      emit(
        AdProviderLoaded(
          filteredProviders,
        ),
      );
    } catch (e) {
      emit(
        AdProviderError(
          e.toString(),
        ),
      );
    }
  }
}