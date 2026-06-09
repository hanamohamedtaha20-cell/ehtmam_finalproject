import 'package:flutter/material.dart';

class ServiceDetailsCard extends StatelessWidget {
  final String serviceType;
  final String petType;
  final String duration;

  const ServiceDetailsCard({
    super.key,
    this.serviceType = '',
    this.petType = '',
    this.duration = '',
  });

  Widget detailRow({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xff4B5A75),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 6),
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
          const SizedBox(height: 15),
          detailRow(
            title: "Service Type",
            value: serviceType.isNotEmpty ? serviceType : '—',
          ),
          if (petType.isNotEmpty)
            detailRow(
              title: "Notes",
              value: petType,
            ),
          detailRow(
            title: "Duration",
            value: duration.isNotEmpty ? duration : '—',
          ),
        ],
      ),
    );
  }
}
