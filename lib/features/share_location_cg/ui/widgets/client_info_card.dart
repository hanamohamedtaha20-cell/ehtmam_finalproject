import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'client_header.dart';
import 'client_status.dart';
import 'start_sharing_button.dart';

class ClientInfoCard extends StatelessWidget {
  final String name;
  final String serviceType;
  final double clientRating;
  final String status;
  final String statusSubtitle;
  final bool isSharing;
  final VoidCallback onShareToggle;

  const ClientInfoCard({
    super.key,
    required this.name,
    required this.serviceType,
    this.clientRating = 0,
    required this.status,
    required this.statusSubtitle,
    required this.isSharing,
    required this.onShareToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(55, 0, 0, 0), blurRadius: 6.r, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientHeader(name: name, serviceType: serviceType, clientRating: clientRating),
          SizedBox(height: 12.h),
          Divider(),
          SizedBox(height: 8.h),
          // 
          SizedBox(height: 12.h),
          StartSharingButton(isSharing: isSharing, onTap: onShareToggle),
        ],
      ),
    );
  }
}