import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({super.key});

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
                  "\$350",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough, // 👈 شطب
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "\$280",
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
            color: Color(0xFF16A34A), // أخضر
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