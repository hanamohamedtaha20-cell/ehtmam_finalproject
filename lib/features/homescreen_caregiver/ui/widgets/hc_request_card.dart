import 'package:flutter/material.dart';

import '../../../booking_caregiver/ui/screens/booking_cg_screen.dart';
import '../../../request_screen_caregiver/ui/screens/booking_details_acc.dart';
import '../../data/model/hc_request_model.dart';

class HcRequestCard extends StatelessWidget {
  const HcRequestCard({
    super.key,
    required this.request,
  });

  final HcRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff111827),
                  ),
                ),
              ),
              Text(
                request.price,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Text(
                'Start: ${request.startDate}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 15, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  request.location,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffEAF3FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xffBBD7FF),
              ),
            ),
            child: Text(
              'Special Requirements: ${request.specialRequirement}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff2563EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF3A8BD7),
                          Color(0xFF97CCFD),
                        ],
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingDetailsAcc(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff111827),
                      side: const BorderSide(color: Color(0xffE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingCgScreenScreen(),
                  ),
                );
              },
              child: Text(
                'View Full Details →',
                style: TextStyle(
                  color: Color(0xFF3A8BD7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}