import 'package:flutter_bloc/flutter_bloc.dart';

import 'bundles_state.dart';

class BundlesCubit extends Cubit<BundlesState> {
  BundlesCubit() : super(const BundlesState());

  void getBundles() {
    emit(
      state.copyWith(
        status: BundlesStatus.success,
        bundles: [
          {
            "id": "1",
            "name": "Starter Bundle",
            "sessions": 3,
            "days": 30,
            "discount": 15,
            "price": 99,
            "sold": 234,
            "features": [
              "3 care sessions",
              "30-day validity",
              "Basic support",
            ],
          },
          {
            "id": "2",
            "name": "Premium Bundle",
            "sessions": 10,
            "days": 60,
            "discount": 30,
            "price": 249,
            "sold": 567,
            "features": [
              "10 care sessions",
              "60-day validity",
              "Priority support",
            ],
          },
          {
            "id": "3",
            "name": "VIP Bundle",
            "sessions": 25,
            "days": 90,
            "discount": 40,
            "price": 499,
            "sold": 189,
            "features": [
              "25 care sessions",
              "90-day validity",
              "Premium support",
            ],
          },
        ],
      ),
    );
  }

  void createBundle({
    required String name,
    required String sessions,
    required String days,
    required String price,
    required String discount,
    required List<String> features,
  }) {
    final updatedBundles = List<Map<String, dynamic>>.from(state.bundles);

    updatedBundles.add({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": name,
      "sessions": int.tryParse(sessions) ?? 0,
      "days": int.tryParse(days) ?? 0,
      "discount": int.tryParse(discount) ?? 0,
      "price": int.tryParse(price) ?? 0,
      "sold": 0,
      "features": features,
    });

    emit(state.copyWith(bundles: updatedBundles));
  }

  void updateBundle({
    required String id,
    required String name,
    required String sessions,
    required String days,
    required String price,
    required String discount,
    required List<String> features,
  }) {
    final updatedBundles = state.bundles.map((bundle) {
      if (bundle['id'] == id) {
        return {
          ...bundle,
          "name": name,
          "sessions": int.tryParse(sessions) ?? 0,
          "days": int.tryParse(days) ?? 0,
          "price": int.tryParse(price) ?? 0,
          "discount": int.tryParse(discount) ?? 0,
          "features": features,
        };
      }
      return bundle;
    }).toList();

    emit(state.copyWith(bundles: updatedBundles));
  }

  void deleteBundle(String id) {
    final updatedBundles = state.bundles.where((e) => e['id'] != id).toList();

    emit(state.copyWith(bundles: updatedBundles));
  }
}