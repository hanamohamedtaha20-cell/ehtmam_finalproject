import 'package:flutter/material.dart';

class PriceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Proposed Price",
                style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                Text("\$350",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough)),
                SizedBox(width: 6),
                Text("\$280",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Best Value",
              style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}