import 'package:flutter/material.dart';


class ServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Services Included",
            style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 8),

        _item("Daily feeding & 2x exercise"),
        _item("Walking and training"),
        _item("Medication administration"),
        _item("Regular updates"),
      ],
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
