import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome back,", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          const Text(
            "Gena Shamel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          /// 🔥 هنا التعديل
          SizedBox(
            width: 344.01,
            height: 55.96,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child:  Text("+ Create New Request"),
            ),
          ),
        ],
      ),
    );
  }
}