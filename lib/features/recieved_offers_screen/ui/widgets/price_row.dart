import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';


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
                if (provider.oldPrice > 0) ...[
                  Text(
                    "${provider.oldPrice.toStringAsFixed(0)} EGP",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 6),
                ],
                Text(
                  "${provider.price.toStringAsFixed(0)} EGP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            if (provider.hourlyRate > 0) ...[
              SizedBox(height: 4),
              Text(
                "${provider.hourlyRate.toStringAsFixed(0)} EGP / hr",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),

        if (provider.bestValue)
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