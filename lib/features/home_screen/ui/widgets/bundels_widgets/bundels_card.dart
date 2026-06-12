import 'package:flutter/material.dart';

import '../../../data/model/bundels_model.dart';
import 'bundels_features.dart';
import 'bundels_header.dart';

class BundleCard extends StatelessWidget {
  final BundleModel bundle;

  const BundleCard({
    super.key,
    required this.bundle,
  });

  List<String> get _features {
    if (bundle.features.isNotEmpty) return bundle.features;

    final items = <String>[
      'Price: ${bundle.displayPrice.toStringAsFixed(0)} SAR',
    ];

    if (bundle.discountPercent > 0) {
      items.add('Discount: ${bundle.discountPercent}%');
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          BundleHeader(bundle: bundle),
          const SizedBox(height: 12),
          BundleFeatures(features: _features),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
