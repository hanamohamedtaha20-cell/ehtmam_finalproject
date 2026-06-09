import 'package:flutter/material.dart';
import 'client_header.dart';
import 'client_status.dart';
import 'start_sharing_button.dart';

class ClientInfoCard extends StatelessWidget {
  final String name;
  final String serviceType;
  final String status;
  final String statusSubtitle;
  final bool isSharing;
  final VoidCallback onShareToggle;

  const ClientInfoCard({
    super.key,
    required this.name,
    required this.serviceType,
    required this.status,
    required this.statusSubtitle,
    required this.isSharing,
    required this.onShareToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(55, 0, 0, 0), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientHeader(name: name, serviceType: serviceType),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Distance', style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: Colors.grey)),
                    const Text('2.3 km', style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Est. Time', style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: Colors.grey)),
                    const Text('15 min', style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          StartSharingButton(isSharing: isSharing, onTap: onShareToggle),
        ],
      ),
    );
  }
}