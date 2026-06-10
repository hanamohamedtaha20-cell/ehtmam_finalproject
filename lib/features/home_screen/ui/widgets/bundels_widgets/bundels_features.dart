import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BundleFeatures extends StatelessWidget {
  final List<String> features;

  const BundleFeatures({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.map(
            (feature) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(feature),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
}