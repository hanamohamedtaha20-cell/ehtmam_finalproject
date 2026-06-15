import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';
import 'offer_card.dart';

class OffersList extends StatelessWidget {
  final String requestId;
  final List<ProviderModel> offers;
  final VoidCallback? onOfferActioned;

  const OffersList({
    super.key,
    required this.requestId,
    required this.offers,
    this.onOfferActioned,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return OfferCard(
          requestId: requestId,
          provider: offers[index],
          onActioned: onOfferActioned,
        );
      },
    );
  }
}
