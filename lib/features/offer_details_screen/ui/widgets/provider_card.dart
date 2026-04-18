import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3A8BD7),
            Color(0xFF6FAFE8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 25),
          SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sarah Adam",
                  style: TextStyle(color: Colors.white)),
              Text("Pet Care • Certified",
                  style: TextStyle(color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }
}