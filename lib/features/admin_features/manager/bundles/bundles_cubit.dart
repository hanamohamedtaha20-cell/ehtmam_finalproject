import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../data/bundle_model.dart';
import 'bundles_state.dart';

class BundlesCubit extends Cubit<BundlesState> {
  final ApiService apiService;

  BundlesCubit({
    ApiService? apiService,
  }) : apiService = apiService ?? ApiService(),
        super(const BundlesState());

  Future<void> getBundles() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: BundlesStatus.loading,
      ),
    );

    try {
      final List<BundleModel> bundles =
      await apiService.getBundles();

      if (!isClosed) {
        emit(
          state.copyWith(
            status: BundlesStatus.success,
            bundles: bundles,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: BundlesStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> createBundle({
    required String name,
    required String sessions,
    required String days,
    required String price,
    required String discount,
    required List<String> features,
  }) async {
    try {
      await apiService.createBundle(
        name: name,
        sessions: sessions,
        validity: days,
        price: price,
        discount: discount,
        features: features,
      );

      await getBundles();
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: BundlesStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> updateBundle({
    required String id,
    required String name,
    required String sessions,
    required String days,
    required String price,
    required String discount,
    required List<String> features,
  }) async {
    try {
      await apiService.updateBundle(
        id: id,
        name: name,
        sessions: sessions,
        validity: days,
        price: price,
        discount: discount,
        features: features,
      );

      await getBundles();
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: BundlesStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> deleteBundle(String id) async {
    try {
      await apiService.deleteBundle(id);

      await getBundles();
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: BundlesStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
