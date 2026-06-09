import 'package:flutter/material.dart';

class ClientBudgetCard extends StatelessWidget {
  final String amount;

  const ClientBudgetCard({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 16,
                color: Colors.grey.shade600,
              ),

              SizedBox(width: 6),

              Text(
                "CLIENT'S BUDGET",

                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          SizedBox(height: 14),

          Container(
            width: double.infinity,

            padding: EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),

            decoration: BoxDecoration(
              color: Color(0xFFEAF8EE),

              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Text(
              amount,

              style: TextStyle(
                color: Color(0xFF00A86B),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}