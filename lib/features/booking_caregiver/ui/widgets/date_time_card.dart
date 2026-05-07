import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({super.key});

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// ICON
          Padding(
            padding: const EdgeInsets.only(top: 2),

            child: Icon(
              icon,
              color: const Color(0xff2F80ED),
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    color: Color(0xff6B7A90),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    color: Color(0xff1F2C44),
                    fontSize: 15,
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
        horizontal: 20,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children: const [

              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff4B5A75),
                size: 20,
              ),

              SizedBox(width: 8),

              Text(
                "DATE & TIME",

                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// DATE
          infoItem(
            icon: Icons.calendar_month_outlined,
            title: "Date",
            value: "2026-04-10",
          ),

          /// TIME
          infoItem(
            icon: Icons.access_time_outlined,
            title: "Time",
            value: "10:00 AM - 2:00 PM",
          ),

          /// LOCATION
          infoItem(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: "123 Salah Salem, Giza",
          ),
        ],
      ),
    );
  }
}