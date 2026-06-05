import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final String status;
  final bool pending;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.status,
    this.pending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              Text(
                amount,

                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: pending
                      ? const Color(0xFFFFF3CD)
                      : const Color(0xFFE8F5E9),

                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Text(
                  status,

                  style: TextStyle(
                    color: pending
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}