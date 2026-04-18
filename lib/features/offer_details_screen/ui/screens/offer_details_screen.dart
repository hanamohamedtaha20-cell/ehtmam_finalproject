import 'package:flutter/material.dart';

import '../widgets/about_provider.dart';
import '../widgets/price_section.dart';
import '../widgets/provider_card.dart';
import '../widgets/reviews.dart';
import '../widgets/services_list.dart';

class OfferDetailsScreen extends StatelessWidget {
  OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),

      body: SafeArea(
        child: Column(
          children: [
        Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
            SizedBox(width: 10),
            Text(
              "Offer Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

        Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProviderCard(),
                    SizedBox(height: 12),
                    PriceSection(),
                    SizedBox(height: 12),
                    // NotesBox(),
                    SizedBox(height: 12),
                    ServicesList(),
                    SizedBox(height: 12),
                    AboutProvider(),
                    SizedBox(height: 12),
                    ReviewsSection(),
                    SizedBox(height: 20),
                    // BottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}