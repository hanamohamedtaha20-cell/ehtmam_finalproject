import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ad_provider_model.dart';
import '../model/repo/ad_provider_repo.dart';
import 'ad_provider_state.dart';

class AdProviderCubit extends Cubit<AdProviderState> {
  final AdProviderRepository repo;

  AdProviderCubit(this.repo) : super(AdProviderInitial());

  List<AdProviderModel> _allProviders = [];

  Future<void> getProviders() async {
    if (isClosed) return;
    emit(AdProviderLoading());
    try {
      final providers = await repo.getProviders();
      _allProviders = providers;
      if (!isClosed) {
        emit(AdProviderLoaded(
          allProviders: _allProviders,
          providers: _allProviders,
        ));
      }
    } catch (e) {
      if (!isClosed) emit(AdProviderError(_extractError(e)));
    }
  }

  void searchProviders(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      emit(AdProviderLoaded(
        allProviders: _allProviders,
        providers: _allProviders,
        searchText: value,
      ));
      return;
    }
    final filtered = _allProviders.where((provider) {
      return provider.name.toLowerCase().contains(query) ||
          provider.service.toLowerCase().contains(query);
    }).toList();
    emit(AdProviderLoaded(
      allProviders: _allProviders,
      providers: filtered,
      searchText: value,
    ));
  }

  /// Returns null on success, an error message string on failure.
  Future<String?> blockProvider(AdProviderModel provider) async {
    try {
      await repo.blockProvider(provider.id);
      _allProviders = _allProviders.where((p) => p.id != provider.id).toList();
      if (!isClosed) {
        final current = state;
        if (current is AdProviderLoaded) {
          emit(AdProviderLoaded(
            allProviders: _allProviders,
            providers: current.providers
                .where((p) => p.id != provider.id)
                .toList(),
            searchText: current.searchText,
          ));
        }
      }
      return null;
    } catch (e) {
      final msg = _extractError(e);
      if (!isClosed) emit(AdProviderError(msg));
      return msg;
    }
  }

  static String _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Request failed';
      }
      return 'Request failed (${e.response?.statusCode ?? 'no response'})';
    }
    return e.toString();
  }
}
