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
      // Show ALL providers so admin can toggle block
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
    final current = state;
    if (current is! AdProviderLoaded) return;
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      emit(AdProviderLoaded(
        allProviders: _allProviders,
        providers: _allProviders,
        searchText: value,
      ));
      return;
    }
    final filtered = _allProviders.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.service.toLowerCase().contains(query);
    }).toList();
    emit(AdProviderLoaded(
      allProviders: _allProviders,
      providers: filtered,
      searchText: value,
    ));
  }

  /// Toggles block status. Returns null on success, error message on failure.
  Future<String?> toggleBlockProvider(AdProviderModel provider) async {
    try {
      await repo.blockProvider(provider.id);
      // Flip isActive locally — same endpoint is a toggle on the backend
      final updated = provider.copyWith(isActive: !provider.isActive);
      _allProviders = _allProviders
          .map((p) => p.id == provider.id ? updated : p)
          .toList();
      if (!isClosed) {
        final current = state;
        if (current is AdProviderLoaded) {
          emit(AdProviderLoaded(
            allProviders: _allProviders,
            providers: current.providers
                .map((p) => p.id == provider.id ? updated : p)
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
