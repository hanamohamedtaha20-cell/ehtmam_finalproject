import '/features/offer_details_screen/data/model/provider_data.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD:lib/features/recieved_offers_screen/ui/widgets/price_row.dart
import '../../data/model/provider_data.dart';

=======
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408:lib/features/offers_screen/ui/widgets/price_row.dart
class PriceRow extends StatelessWidget {
  const PriceRow({super.key,required this.provider});
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// 🔹 السعر
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// label
            Text(
              "Proposed Price",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            SizedBox(height: 4),


            Row(
              children: [
                Text(
                  "\$${provider.oldPrice}",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough, // 👈 شطب
                  ),
                ),
                SizedBox(width: 6),
                Text(
                "\$${provider.price}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),

        /// 🔹 Best Value badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF16A34A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            "Best Value",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),

      ],
    );
  }
}