import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  final String date;
  final String time;
  final String location;

  const DateTimeCard({
    super.key,
    this.date = '',
    this.time = '',
    this.location = '',
  });

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: const Color(0xff2F80ED),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff6B7A90),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: const TextStyle(
                    color: Color(0xff1F2C44),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff4B5A75),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "DATE & TIME",
                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          infoItem(
            icon: Icons.calendar_month_outlined,
            title: "Date",
            value: date,
          ),
          infoItem(
            icon: Icons.access_time_outlined,
            title: "Time",
            value: time,
          ),
          infoItem(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: location,
          ),
        ],
      ),
    );
  }
}
