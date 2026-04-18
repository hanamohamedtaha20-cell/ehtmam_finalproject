import 'package:flutter/material.dart';
import 'offer_card.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        OfferCard(),
        OfferCard(),
        OfferCard()
      ],
    );
  }
}
