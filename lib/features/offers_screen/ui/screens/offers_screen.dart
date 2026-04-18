import 'package:flutter/material.dart';
import '../widgets/offer_header.dart';
import '../widgets/offers_list.dart';
import '../widgets/request_summary_card.dart';

class OffersScreen extends StatelessWidget {
   OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF5F6FA),

      body: SafeArea(
        child: Column(
          children:  [
            OffersHeader(),
            RequestSummaryCard(),
            Expanded(child: OffersList()),
          ],
        ),
      ),
    );
  }
}