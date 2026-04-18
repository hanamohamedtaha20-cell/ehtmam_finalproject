import 'package:flutter/material.dart';

class AboutProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Provider",
            style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 6),

        Text(
          "With over 5 years of professional experience...",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}