import 'package:flutter/material.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  Widget detailRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// TITLE
          Expanded(
            child: Text(
              title,

              style: TextStyle(
                color: Color(0xff4B5A75),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(width: 15),

          /// VALUE
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: TextStyle(
                color: Color(0xff1F2C44),
                fontSize: 14,
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

      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 6,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children: [

              Icon(
                Icons.inventory_2_outlined,
                color: Color(0xff4B5A75),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                "SERVICE DETAILS",

                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

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
            padding: EdgeInsets.only(bottom: 0),

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