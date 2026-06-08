import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';


class NotesBox extends StatelessWidget {
  const NotesBox({
    super.key,
    required this.provider,
  });

  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Title
        Text(
          "Provider Notes:",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),

        SizedBox(height: 6),

        /// 🔹 Box
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Text(
            provider.notes,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}