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
           Text("Welcome back,", style: TextStyle(color: Colors.grey)),
           SizedBox(height: 4),
           Text(
            "Gena Shamel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
           SizedBox(height: 12),

          SizedBox(
            width: 344.01,
            height: 55.96,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3A8BD7),
                    Color(0xFFD8E3E9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // 👈 أسود
                    offset: Offset(0, 6), // 👈 تحت
                    blurRadius: 10, // 👈 نعومة
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: const Center(
                    child: Text(
                      "+ Create New Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}