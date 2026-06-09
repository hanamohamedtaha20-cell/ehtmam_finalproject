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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0,4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
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

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
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
                        ? const Color(0xFFE68A00)
                        : const Color(0xFF2E7D32),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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