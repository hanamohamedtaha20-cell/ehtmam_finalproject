import 'package:flutter/material.dart';

import '../../../data/model/bundels_model.dart';

class BundleHeader extends StatelessWidget {
  final BundleModel bundle;

  const BundleHeader({
    super.key,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          child: Icon(Icons.local_offer_outlined),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bundle.bundleName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (bundle.discountPercent > 0)
                Text(
                  'Discount ${bundle.discountPercent}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              bundle.displayPrice.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'SAR',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}