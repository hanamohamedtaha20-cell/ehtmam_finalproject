import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({super.key,required this.provider});
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// 🔹 Rating
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text(
                      "${provider.rating}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "(${provider.reviewsCount})",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          /// 🔹 Divider
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
          ),

          /// 🔹 Experience
          Column(
            children: [
              Text(
                "5+",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "years experience",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          /// 🔹 Divider
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
          ),

          /// 🔹 Services
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "${provider.completed}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Completed Services",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
