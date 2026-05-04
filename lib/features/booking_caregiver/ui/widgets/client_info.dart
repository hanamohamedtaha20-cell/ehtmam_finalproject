import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/reusable_info_card.dart';
import 'package:flutter/material.dart';

import 'info_row.dart';

class ClientInfoCard extends StatelessWidget {
  const ClientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'CLIENT INFORMATION',
      icon: Icons.person_outline,
      children: [
        InfoRow('Name', 'Menaa adel'),
        InfoRow('Phone', '+201001867005'),
        InfoRow('Email', 'Menaa.adel@gmail.com'),
      ],
    );
  }
}

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'SERVICE DETAILS',
      icon: Icons.pets,
      children: [
        InfoRow('Service Type', 'Pet Care'),
        InfoRow('Pet Type', 'Golden Retriever'),
        InfoRow('Duration', '4 hours'),
      ],
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'DATE & TIME',
      icon: Icons.calendar_today,
      children:  [
        InfoRow('Date', '2026-04-10'),
        InfoRow('Time', '10:00 AM - 2:00 PM'),
        InfoRow('Location', '123 Salem Sakem, Giza'),
      ],
    );
  }
}

class SpecialInstructionsCard extends StatelessWidget {
  const SpecialInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'SPECIAL INSTRUCTIONS',
      icon: Icons.note_alt_outlined,
      children:  [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Max tries to play fetch and needs his medication at 12 PM. Please make sure he has fresh water at all times.",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}