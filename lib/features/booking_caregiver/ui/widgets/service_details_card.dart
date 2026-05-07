import 'package:flutter/material.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  Widget detailRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// TITLE
          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                color: Color(0xff4B5A75),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// VALUE
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: const TextStyle(
                color: Color(0xff1F2C44),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
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
        vertical: 22,
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
                Icons.inventory_2_outlined,
                color: Color(0xff4B5A75),
                size: 20,
              ),

              SizedBox(width: 8),

              Text(
                "SERVICE DETAILS",

                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// DETAILS
          detailRow(
            title: "Service Type",
            value: "Pet Care",
          ),

          detailRow(
            title: "Pet Name",
            value: "Max",
          ),

          detailRow(
            title: "Pet Type",
            value: "Golden Retriever",
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 0),

            child: detailRow(
              title: "Duration",
              value: "4 hours",
            ),
          ),
        ],
      ),
    );
  }
}