import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/price_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/provider_info.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/specialization_box.dart';
import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';
import '../screens/offer_details_screen.dart';
import 'notes.dart';


class OfferCard extends StatelessWidget {
  final ProviderModel provider;

  const OfferCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          ProviderInfo(provider: provider),

          SizedBox(height: 10),

          RatingRow(provider: provider),

          SizedBox(height: 10),

          SpecializationBox(provider: provider,),

          SizedBox(height: 10),

          // NotesBox(provider: provider,),

          SizedBox(height: 10),

          PriceRow(provider: provider),

          SizedBox(height: 10),

          Divider(thickness: 0.2),

          SizedBox(height: 10),

          ActionButtonsRow(
            firstText: "View Detils",
            secondText: "Process Payment",

            onFirstTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfferDetailsScreen()));
            },

            onSecondTap: () {

            },
          ),
        ],
      ),
    );
  }
}