import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhyChooseUsCard extends StatelessWidget {
  const WhyChooseUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      "Save up to 40%",
      "No booking fees",
      "Priority scheduling",
      "Flexible cancellation",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F80ED),
            Color(0xFF1C6DD0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Why Choose Bundles?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (_, index) {
              return Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      features[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}