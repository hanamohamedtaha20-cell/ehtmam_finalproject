import 'package:ehtemam_final_project/features/offers_screen/ui/widgets/price_row.dart';
import 'package:ehtemam_final_project/features/offers_screen/ui/widgets/provider_info.dart';
import 'package:ehtemam_final_project/features/offers_screen/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/offers_screen/ui/widgets/specialization_box.dart';
import 'package:flutter/material.dart';
import 'buttons.dart';
import 'notes.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:   EdgeInsets.only(bottom: 16),
      padding:  EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0,6),
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProviderInfo(),
          SizedBox(height: 10),
          RatingRow(),
          SizedBox(height: 10),
          SpecializationBox(),
          SizedBox(height: 10),
          NotesBox(),
          SizedBox(height: 10),
          PriceRow(),
          SizedBox(height: 10),
          Divider(thickness: 0.2),
          SizedBox(height: 10),
          ActionButtons(),
        ],
      ),
    );
  }
}
