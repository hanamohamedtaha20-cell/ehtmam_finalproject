import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';
import 'offer_card.dart';

class OffersList extends StatelessWidget {
  final ProviderModel provider;

  const OffersList({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [


        OfferCard(provider: provider),
        OfferCard(provider: provider),
        OfferCard(provider: provider),

      ],
    );
  }
}