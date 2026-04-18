import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reviews (127)",
            style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 10),

        _review("Ahmed", "Great service!", 5),
        _review("Mona", "Very professional", 5),
      ],
    );
  }

  Widget _review(String name, String text, int rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(text),
        ],
      ),
    );
  }
}