import 'package:flutter/material.dart';

class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(16),
      child: Row(
        children:  [
          IconButton(
              onPressed:(){
                Navigator.pop(context);
              },
              icon:Icon(Icons.arrow_back)
          ),
          SizedBox(width: 10),
          Text(
            "Received Offers",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}