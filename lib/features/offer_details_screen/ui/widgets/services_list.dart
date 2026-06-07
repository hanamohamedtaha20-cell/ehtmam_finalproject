import 'package:flutter/material.dart';

class ServicesList extends StatelessWidget {
  ServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FA), // 👈 خلفية فاتحة
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Title
          Text(
            "Services Includes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          SizedBox(height: 12),

          /// 🔹 Items
          _item("Daily feeding (2-3 times per day)"),
          _item("Morning and evening walks"),
          _item("Professional grooming session"),
          _item("Playtime and exercise"),
          _item("Basic health monitoring"),
          _item("Photo/video updates daily"),
          _item("Emergency vet contact available"),
        ],
      ),
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Check Icon
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFFEAF8F0), // خلفية خفيفة
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 13,
                color: Color(0xFF22C55E), // أخضر أنضف
              ),
            ),
          ),

          SizedBox(width: 10),

          /// 🔹 Text
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
