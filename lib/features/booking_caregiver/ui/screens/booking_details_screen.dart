import 'package:flutter/material.dart';

import '../widgets/client_info.dart';
import '../widgets/date_time_card.dart';
import '../widgets/earnings_button.dart';
import '../widgets/header_card.dart';
import '../widgets/service_details_card.dart';
import '../widgets/special_instructions_card.dart';
import '../widgets/tabs.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E5CFF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BookingHeader(),
            const SizedBox(height: 16),
            const BookingTabs(),
            const SizedBox(height: 20),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ClientInfoCard(),
                   SizedBox(height: 16),
                  ServiceDetailsCard(),
                   SizedBox(height: 16),
                  DateTimeCard(),
                   SizedBox(height: 16),
                  SpecialInstructionsCard(),
                ],
              ),
            ),
             SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet:  EarningsBottomBar(),

    );
  }
}