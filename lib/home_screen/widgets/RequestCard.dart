import 'package:flutter/material.dart';

class RequestCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final String description;
  final String provider;

  const RequestCardWidget({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.description,
    required this.provider,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12,right: 8, left: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),),
                const SizedBox(height: 6),
                Text(
                  "Starts: $date",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  provider,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF39DAF6)),
                ),
              ],
            ),
          ),
          Expanded(

            child:Container(

                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                       Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: statusColor, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                )
          ),
        ],
      ),
    );
  }
}