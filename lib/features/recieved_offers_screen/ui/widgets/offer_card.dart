import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/price_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/provider_info.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/notes.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/specialization_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';
import '../../utils/offer_accept_handler.dart';
import '../screens/offer_details_screen.dart';


class OfferCard extends StatelessWidget {
  final String requestId;
  final ProviderModel provider;
  final VoidCallback? onActioned;

  const OfferCard({
    super.key,
    required this.requestId,
    required this.provider,
    this.onActioned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          ProviderInfo(provider: provider),

          SizedBox(height: 10.h),

          RatingRow(provider: provider),

          SizedBox(height: 10.h),

          if (provider.specialization.isNotEmpty) ...[
            SpecializationBox(provider: provider),
            SizedBox(height: 10.h),
          ],

          if (provider.notes.isNotEmpty) ...[
            NotesBox(provider: provider),
            SizedBox(height: 10.h),
          ],

          PriceRow(provider: provider),

          SizedBox(height: 10.h),

          Divider(thickness: 0.2),

          SizedBox(height: 10.h),

          ActionButtonsRow(
            firstText: "View Detils",
            secondText: "Accept",

            onFirstTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OfferDetailsScreen(
                    requestId: requestId,
                    offerId: provider.id,
                  ),
                ),
              );
            },

            onSecondTap: () async {
              await acceptOffer(
                context: context,
                offerId: provider.id,
                requestId: requestId,
                offerPrice: provider.price,
              );
              onActioned?.call();
            },
          ),
        ],
      ),
    );
  }
}