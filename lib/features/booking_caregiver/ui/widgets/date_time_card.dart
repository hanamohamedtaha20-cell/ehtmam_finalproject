import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({super.key});

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// ICON
          Padding(
            padding: EdgeInsets.only(top: 2),

            child: Icon(
              icon,
              color: Color(0xff2F80ED),
              size: 20,
            ),
          ),

           SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    color: Color(0xff6B7A90),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  value,

                  style: TextStyle(
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

      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children:  [

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

           SizedBox(height: 15),

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