import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ad_provider_model.dart';
import '../model/repo/ad_provider_repo.dart';
import '../model/repo/ad_provider_repository.dart';
import 'ad_provider_state.dart';

class AdProviderCubit extends Cubit<AdProviderState> {
  final AdProviderRepository repo;

  AdProviderCubit(this.repo)
      : super(AdProviderInitial());

  List<AdProviderModel> _allProviders = [];

  Future<void> getProviders() async {
    emit(AdProviderLoading());

    try {
      final providers =
      await repo.getProviders();

      _allProviders = providers;

      emit(
        AdProviderLoaded(
          allProviders: _allProviders,
          providers: _allProviders,
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

  void searchProviders(
      String value,
      ) {
    final query =
    value.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        AdProviderLoaded(
          allProviders: _allProviders,
          providers: _allProviders,
          searchText: value,
        ),
      );
      return;
    }

    final filtered =
    _allProviders.where((provider) {
      return provider.name
          .toLowerCase()
          .contains(query) ||
          provider.service
              .toLowerCase()
              .contains(query);
    }).toList();

    emit(
      AdProviderLoaded(
        allProviders: _allProviders,
        providers: filtered,
        searchText: value,
      ),
    );
  }

  Future<void> blockProvider(
      AdProviderModel provider,
      ) async {
    try {
      await repo.blockProvider(
        provider.id,
      );

      await getProviders();
    } catch (e) {
      emit(
        AdProviderError(
          e.toString(),
        ),
      );
    }
  }
}