import 'package:flutter/material.dart';
import '../widgets/client_info.dart';
import '../widgets/earnings_button.dart';
import '../widgets/header_card.dart';
import '../widgets/tabs.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF5E5CFF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             BookingHeader(),
             SizedBox(height: 16),
             BookingTabs(),
             SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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