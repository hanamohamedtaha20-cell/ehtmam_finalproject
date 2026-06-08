import 'package:flutter/material.dart';
import '../widgets/earnings_header_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/stats_card.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Earnings",
          style: TextStyle(
            color: Color(0xFF2B2D42),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const EarningsHeaderCard(),

            const SizedBox(height: 18),

            const Row(
              children: [
                Expanded(
                  child: StatsCard(
                    value: "43",
                    title: "Jobs",
                    color: Color(0xFF4A90E2),
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: StatsCard(
                    value: "1120",
                    title: "Avg Job",
                    color: Color(0xFF4CAF50),
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: StatsCard(
                    value: "128h",
                    title: "Hours",
                    color: Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
             SizedBox(height: 24),

            RecentTransactionsSection(),
          ],
        ),
      ),
    );
  }
}