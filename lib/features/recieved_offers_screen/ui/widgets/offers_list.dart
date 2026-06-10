import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';
import 'offer_card.dart';

class OffersList extends StatelessWidget {
  final String requestId;
  final List<ProviderModel> offers;

  const OffersList({
    super.key,
    required this.requestId,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return OfferCard(
          requestId: requestId,
          provider: offers[index],
        );
      },
    );
  }
}
